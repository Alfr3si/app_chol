// lib/modules/modulo3/actividades/actividad_memorama_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_memorama.dart';

class ActividadMemoramaScreen extends StatefulWidget {
  const ActividadMemoramaScreen({super.key});

  @override
  State<ActividadMemoramaScreen> createState() => _ActividadMemoramaScreenState();
}

class _ActividadMemoramaScreenState extends State<ActividadMemoramaScreen> {
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
      final String jsonString = await rootBundle.loadString('assets/data/module_3_escuela.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> muestrasLexicas = jsonData['muestras_lexicas'] ?? [];
      final List<dynamic> muestrasSintacticas = jsonData['muestras_sintacticas'] ?? [];
      final List<dynamic> todasLasMuestras = [...muestrasLexicas, ...muestrasSintacticas];

      // Filtro estricto: texto válido en Ch'ol + imagen obligatoria + audio obligatorio
      final filtrados = todasLasMuestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where((item) =>
              item.chol.trim().isNotEmpty &&
              item.chol.trim().toLowerCase() != 'no tiene traducción' &&
              item.espanol.trim().isNotEmpty &&
              item.pathImagen != null &&
              item.pathImagen!.trim().isNotEmpty &&
              item.pathAudio != null &&
              item.pathAudio!.trim().isNotEmpty);

      // Deduplicamos por palabra en Ch'ol para evitar duplicados en el tablero
      final Map<String, ItemVocabulario> unicosPorChol = {};
      for (var item in filtrados) {
        unicosPorChol.putIfAbsent(item.chol.trim().toLowerCase(), () => item);
      }

      setState(() {
        _listaItems = unicosPorChol.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar datos del memorama del módulo 3: $e');
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
          title: const Text('Cargando memorama...', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (_listaItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text('Memorama', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay suficientes elementos con imagen y audio para el memorama.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
          ),
        ),
      );
    }

    return ActividadMemorama(
      tituloActividad: 'Actividad 4: Memorama',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
