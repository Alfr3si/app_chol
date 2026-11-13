// lib/modules/modulo1/actividades/actividad_memorama_screen.dart
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
      final String jsonString = await rootBundle.loadString('assets/data/module_1_familia.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Combinamos muestras léxicas y sintácticas para el memorama
      final List<dynamic> muestrasLexicas = jsonData['muestras_lexicas'] ?? [];
      final List<dynamic> muestrasSintacticas = jsonData['muestras_sintacticas'] ?? [];
      final List<dynamic> todasLasMuestras = [...muestrasLexicas, ...muestrasSintacticas];

      setState(() {
        _listaItems = todasLasMuestras
            .map((item) => ItemVocabulario.fromJson(item))
            .where((item) =>
                item.chol.isNotEmpty &&
                item.pathImagen != null &&
                item.pathImagen!.isNotEmpty)
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar datos del memorama: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(backgroundColor: Colors.brown.shade800, title: const Text('Cargando memorama...')),
        body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (_listaItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.brown.shade800, title: const Text('Memorama')),
        body: const Center(
          child: Text('No hay suficientes elementos con imagen para el memorama.'),
        ),
      );
    }

    return ActividadMemorama(
      tituloActividad: 'Memorama: Palabra e Imagen',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
