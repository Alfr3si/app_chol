// lib/modules/modulo4/actividades/actividad_alimentos_relacionar_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_relacionar.dart';

class ActividadAlimentosRelacionarScreen extends StatefulWidget {
  final String categoriaFiltro;

  const ActividadAlimentosRelacionarScreen({
    super.key,
    this.categoriaFiltro = 'alimentos',
  });

  @override
  State<ActividadAlimentosRelacionarScreen> createState() =>
      _ActividadAlimentosRelacionarScreenState();
}

class _ActividadAlimentosRelacionarScreenState
    extends State<ActividadAlimentosRelacionarScreen> {
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

      final List<dynamic> muestrasLexicas = jsonData['muestras_lexicas'] ?? [];
      final List<dynamic> muestrasSintacticas =
          jsonData['muestras_sintacticas'] ?? [];
      final List<dynamic> todasLasMuestras = [
        ...muestrasLexicas,
        ...muestrasSintacticas,
      ];

      final String filtroNormalizado =
          widget.categoriaFiltro.trim().toLowerCase();

      // Filtro estricto: categoría solicitada + texto válido en Ch'ol y Español
      final filtrados = todasLasMuestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where(
            (item) =>
                (item.categoria ?? '').trim().toLowerCase() ==
                    filtroNormalizado &&
                item.chol.trim().isNotEmpty &&
                item.chol.trim().toLowerCase() != 'no tiene traducción' &&
                item.espanol.trim().isNotEmpty,
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
      debugPrint('Error al cargar datos de alimentos para relacionar: $e');
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
            'Cargando Alimentos...',
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
            'Une alimentos',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay elementos de alimentos disponibles para relacionar en este módulo.',
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
      tituloActividad: 'Une alimentos',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
      moduloId: 4,
      actividadNumero: 5,
    );
  }
}
