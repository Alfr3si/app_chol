// lib/modules/modulo1/actividades/actividad_saludos_audio_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para rootBundle

import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_audio.dart';

class ActividadSaludosAudioScreen extends StatefulWidget {
  const ActividadSaludosAudioScreen({super.key});

  @override
  State<ActividadSaludosAudioScreen> createState() => _ActividadSaludosAudioScreenState();
}

class _ActividadSaludosAudioScreenState extends State<ActividadSaludosAudioScreen> {
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

      setState(() {
        _listaSaludos = muestras
            .map((item) => ItemVocabulario.fromJson(item))
            // 🔍 FILTRO FLEXIBLE: Categoría 'saludos' con texto válido en Ch'ol y Español
            .where(
              (item) =>
                  item.categoria == 'saludos' &&
                  item.chol.isNotEmpty &&
                  item.espanol.isNotEmpty,
            )
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar el JSON de saludos: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si todavía está cargando el archivo, mostramos un indicador visual
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

    // Si ocurrió algún error o está vacío
    if (_listaSaludos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('No se pudieron cargar los datos de saludos.'),
        ),
      );
    }

    // Retornamos la pantalla refactorizada con los datos filtrados exclusivamente de la categoría 'saludos'
    return ActividadAudio(
      tituloActividad: 'Actividad 1: Saludos',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaSaludos,
    );
  }
}
