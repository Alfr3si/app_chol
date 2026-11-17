// lib/modules/modulo3/actividades/actividad_numeros_audio_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_audio.dart';

class ActividadNumerosAudioScreen extends StatefulWidget {
  final String categoriaFiltro;
  const ActividadNumerosAudioScreen({
    super.key,
    this.categoriaFiltro = 'numeros',
  });

  @override
  State<ActividadNumerosAudioScreen> createState() =>
      _ActividadNumerosAudioScreenState();
}

class _ActividadNumerosAudioScreenState
    extends State<ActividadNumerosAudioScreen> {
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
      final String jsonString = await rootBundle.loadString(
        'assets/data/module_3_escuela.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> muestras = jsonData['muestras_lexicas'] ?? [];

      // Filtro estricto por categoría 'numeros', texto válido y audio obligatorio
      final filtrados = muestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where(
            (item) =>
                (item.categoria ?? '').trim().toLowerCase() ==
                    widget.categoriaFiltro.trim().toLowerCase() &&
                item.chol.trim().isNotEmpty &&
                item.chol.trim().toLowerCase() != 'no tiene traducción' &&
                item.espanol.trim().isNotEmpty &&
                item.pathAudio != null &&
                item.pathAudio!.trim().isNotEmpty,
          );

      // Evitamos duplicados de la misma expresión en Ch'ol
      final Map<String, ItemVocabulario> unicosPorChol = {};
      for (var item in filtrados) {
        unicosPorChol.putIfAbsent(item.chol.trim().toLowerCase(), () => item);
      }

      setState(() {
        _listaItems = unicosPorChol.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar el JSON de números: $e');
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
            'Cargando Números...',
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
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text('Aviso', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text('No hay números con audio disponible en esta actividad.'),
        ),
      );
    }

    return ActividadAudio(
      tituloActividad: 'Actividad 3: Números',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
