// lib/modules/modulo3/actividades/actividad_acciones_relacionar_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_relacionar.dart';

class ActividadAccionesRelacionarScreen extends StatefulWidget {
  final String categoriaFiltro;
  const ActividadAccionesRelacionarScreen({
    super.key,
    this.categoriaFiltro = 'acciones',
  });

  @override
  State<ActividadAccionesRelacionarScreen> createState() =>
      _ActividadAccionesRelacionarScreenState();
}

class _ActividadAccionesRelacionarScreenState
    extends State<ActividadAccionesRelacionarScreen> {
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

      // Filtro estricto por categoría 'acciones', texto válido y manejo seguro de null
      final filtrados = muestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where(
            (item) =>
                (item.categoria ?? '').trim().toLowerCase() ==
                    widget.categoriaFiltro.trim().toLowerCase() &&
                item.chol.trim().isNotEmpty &&
                item.chol.trim().toLowerCase() != 'no tiene traducción' &&
                item.espanol.trim().isNotEmpty,
          );

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
      debugPrint('Error al cargar datos de acciones para relacionar: $e');
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
            'Cargando Acciones...',
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
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay elementos disponibles para relacionar en esta categoría.',
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

    return ActividadRelacionar(
      tituloActividad: 'Actividad 5: Acciones',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
