// lib/modules/modulo1/actividades/actividad_saludos_audio_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_audio.dart';

class ActividadSaludosAudioScreen extends StatefulWidget {
  const ActividadSaludosAudioScreen({super.key});

  @override
  State<ActividadSaludosAudioScreen> createState() =>
      _ActividadSaludosAudioScreenState();
}

class _ActividadSaludosAudioScreenState
    extends State<ActividadSaludosAudioScreen> {
  List<ItemVocabulario> _listaSaludos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosDesdeJson();
  }

  Future<void> _cargarDatosDesdeJson() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/module_1_familia.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> muestras = jsonData['muestras_lexicas'] ?? [];

      // Filtro estricto con manejo seguro de null en categoria
      final filtrados = muestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where(
            (item) =>
                (item.categoria ?? '').trim().toLowerCase() == 'saludos' &&
                item.chol.trim().isNotEmpty &&
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
        _listaSaludos = unicosPorChol.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar el JSON de saludos: $e');
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
            'Cargando Saludos...',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    if (_listaSaludos.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text('Aviso', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text('No hay saludos con audio disponible en este módulo.'),
        ),
      );
    }

    return ActividadAudio(
      tituloActividad: 'Escucha y saluda',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaSaludos,
      moduloId: 1,
      actividadNumero: 1,
    );
  }
}
