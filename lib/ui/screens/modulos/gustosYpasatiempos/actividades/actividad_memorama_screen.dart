// lib/modules/modulo4/actividades/actividad_memorama_screen.dart
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
      final String jsonString =
          await rootBundle.loadString('assets/data/module_4_gustosYpasatiempos.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> muestrasLexicas = jsonData['muestras_lexicas'] ?? [];
      final List<dynamic> muestrasSintacticas =
          jsonData['muestras_sintacticas'] ?? [];
      final List<dynamic> todasLasMuestras = [
        ...muestrasLexicas,
        ...muestrasSintacticas,
      ];

      // Filtro: categorías 'alimentos' o 'frutas' + texto válido en Ch'ol/Español + imagen obligatoria
      final filtrados = todasLasMuestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where((item) {
            final categoria = (item.categoria ?? '').trim().toLowerCase();
            final esCategoriaValida =
                categoria == 'alimentos' || categoria == 'frutas';
            final tieneTextoValido = item.chol.trim().isNotEmpty &&
                item.chol.trim().toLowerCase() != 'no tiene traducción' &&
                item.espanol.trim().isNotEmpty;
            final tieneImagen = item.pathImagen != null &&
                item.pathImagen!.trim().isNotEmpty;

            return esCategoriaValida && tieneTextoValido && tieneImagen;
          });

      // Deduplicamos por expresión en Ch'ol para evitar pares repetidos
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
      debugPrint('Error al cargar datos del memorama del módulo 4: $e');
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
            'Cargando memorama...',
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
            'Actividad 4: Memorama',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay suficientes elementos de alimentos y frutas con imagen para el memorama.',
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

    return ActividadMemorama(
      tituloActividad: 'Actividad 4: Memorama',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
