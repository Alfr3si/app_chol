// lib/modules/modulo4/actividades/actividad_pasatiempos_imagen_audio_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_imagen_audio.dart';

class ActividadPasatiemposImagenAudioScreen extends StatefulWidget {
  final String categoriaFiltro;

  const ActividadPasatiemposImagenAudioScreen({
    super.key,
    this.categoriaFiltro = 'pasatiempos',
  });

  @override
  State<ActividadPasatiemposImagenAudioScreen> createState() =>
      _ActividadPasatiemposImagenAudioScreenState();
}

class _ActividadPasatiemposImagenAudioScreenState
    extends State<ActividadPasatiemposImagenAudioScreen> {
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

      final filtrados = muestras
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
      debugPrint('Error al cargar datos de pasatiempos: $e');
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
            'Cargando Pasatiempos...',
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
            'Conoce pasatiempos',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay suficientes elementos de pasatiempos con imagen y audio en esta actividad.',
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
      tituloActividad: 'Conoce pasatiempos',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
      moduloId: 4,
      actividadNumero: 1,
    );
  }
}
