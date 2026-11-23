// lib/modules/modulo3/actividades/actividad_oficios_imagen_audio_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_imagen_audio.dart';

class ActividadOficiosImagenAudioScreen extends StatefulWidget {
  const ActividadOficiosImagenAudioScreen({super.key});

  @override
  State<ActividadOficiosImagenAudioScreen> createState() =>
      _ActividadOficiosImagenAudioScreenState();
}

class _ActividadOficiosImagenAudioScreenState
    extends State<ActividadOficiosImagenAudioScreen> {
  List<ItemVocabulario> _listaItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosDesdeJson();
  }

  Future<void> _cargarDatosDesdeJson() async {
    try {
      // Verifica que el nombre del JSON coincida con tu asset en pubspec.yaml
      final String jsonString =
          await rootBundle.loadString('assets/data/module_3_escuela.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> muestras = jsonData['muestras_lexicas'] ?? [];

      // Filtro estricto: categoría 'oficios' (Maestro, Campesino, Pescador, Curandero) con imagen y audio obligatorios
      final filtrados = muestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where((item) =>
              (item.categoria ?? '').trim().toLowerCase() == 'oficios' &&
              item.chol.trim().isNotEmpty &&
              item.espanol.trim().isNotEmpty &&
              item.chol.trim().toLowerCase() != 'no tiene traducción' &&
              item.pathImagen != null &&
              item.pathImagen!.trim().isNotEmpty &&
              item.pathAudio != null &&
              item.pathAudio!.trim().isNotEmpty);

      // Deduplicamos por palabra en Ch'ol
      final Map<String, ItemVocabulario> unicosPorChol = {};
      for (var item in filtrados) {
        unicosPorChol.putIfAbsent(item.chol.trim().toLowerCase(), () => item);
      }

      setState(() {
        _listaItems = unicosPorChol.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar datos de oficios: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text(
            'Cargando Oficios...',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
            child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (_listaItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text('Aviso', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay suficientes elementos con imagen y audio en esta categoría.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
        ),
      );
    }

    return ActividadImagenAudio(
      tituloActividad: 'Conoce oficios',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
      moduloId: 3,
      actividadNumero: 1,
    );
  }
}
