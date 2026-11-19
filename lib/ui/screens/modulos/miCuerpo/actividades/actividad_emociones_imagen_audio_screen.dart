// lib/modules/modulo5/actividades/actividad_emociones_imagen_audio_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_imagen_audio.dart';

class ActividadEmocionesImagenAudioScreen extends StatefulWidget {
  final String categoriaFiltro;

  const ActividadEmocionesImagenAudioScreen({
    super.key,
    this.categoriaFiltro = 'emociones',
  });

  @override
  State<ActividadEmocionesImagenAudioScreen> createState() =>
      _ActividadEmocionesImagenAudioScreenState();
}

class _ActividadEmocionesImagenAudioScreenState
    extends State<ActividadEmocionesImagenAudioScreen> {
  List<ItemVocabulario> _listaItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosDesdeJson();
  }

  Future<void> _cargarDatosDesdeJson() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/module_5_miCuerpo.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> muestrasLexicas = jsonData['muestras_lexicas'] ?? [];
      final List<dynamic> muestrasSintacticas =
          jsonData['muestras_sintacticas'] ?? [];
      final List<dynamic> todasLasMuestras = [
        ...muestrasLexicas,
        ...muestrasSintacticas,
      ];

      final String filtroNormalizado =
          widget.categoriaFiltro.trim().toLowerCase();

      final filtrados = todasLasMuestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where(
            (item) =>
                (item.categoria ?? '').trim().toLowerCase() ==
                    filtroNormalizado &&
                item.chol.trim().isNotEmpty &&
                item.chol.trim().toLowerCase() != 'no tiene traducción' &&
                item.espanol.trim().isNotEmpty &&
                item.pathImagen != null &&
                item.pathImagen!.trim().isNotEmpty &&
                item.pathAudio != null &&
                item.pathAudio!.trim().isNotEmpty,
          );

      final Map<String, ItemVocabulario> unicosPorChol = {};
      for (final item in filtrados) {
        unicosPorChol.putIfAbsent(item.chol.trim().toLowerCase(), () => item);
      }

      if (!mounted) return;
      setState(() {
        _listaItems = unicosPorChol.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar datos de emociones: $e');
      if (!mounted) return;
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
            'Cargando Emociones...',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    if (_listaItems.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text(
            'Actividad: Emociones',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay suficientes elementos de emociones con imagen y audio en esta actividad.',
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
      tituloActividad: 'Actividad: Emociones',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
