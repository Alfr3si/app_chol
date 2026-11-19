// lib/modules/modulo4/actividades/actividad_numeros_audio_screen.dart
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
      final String jsonString = await rootBundle.loadString(
        'assets/data/module_4_gustosYpasatiempos.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> muestras = jsonData['muestras_lexicas'] ?? [];
      final String filtroNormalizado =
          widget.categoriaFiltro.trim().toLowerCase();

      // Filtro estricto: categoría solicitada + texto válido en Ch'ol y Español + audio obligatorio
      final filtrados = muestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where(
            (item) =>
                (item.categoria ?? '').trim().toLowerCase() ==
                    filtroNormalizado &&
                item.chol.trim().isNotEmpty &&
                item.chol.trim().toLowerCase() != 'no tiene traducción' &&
                item.espanol.trim().isNotEmpty &&
                item.pathAudio != null &&
                item.pathAudio!.trim().isNotEmpty,
          );

      // Evitamos duplicados de la misma expresión en Ch'ol
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
      debugPrint('Error al cargar el JSON de audio para números: $e');
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
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text(
            'Actividad 2: Números y Audio',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay elementos de números con audio disponible en esta actividad.',
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

    return ActividadAudio(
      tituloActividad: 'Actividad 2: Números y Audio',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
