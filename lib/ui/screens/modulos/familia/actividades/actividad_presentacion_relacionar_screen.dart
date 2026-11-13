// lib/modules/modulo1/actividades/actividad_presentacion_relacionar_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_relacionar.dart';

class ActividadPresentacionRelacionarScreen extends StatefulWidget {
  const ActividadPresentacionRelacionarScreen({super.key});

  @override
  State<ActividadPresentacionRelacionarScreen> createState() => _ActividadPresentacionRelacionarScreenState();
}

class _ActividadPresentacionRelacionarScreenState extends State<ActividadPresentacionRelacionarScreen> {
  List<ItemVocabulario> _listaItemsPresentacion = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosPresentacion();
  }

  Future<void> _cargarDatosPresentacion() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/module_1_familia.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Combinamos tanto muestras léxicas como sintácticas del JSON
      final List<dynamic> lexicas = jsonData['muestras_lexicas'] ?? [];
      final List<dynamic> sintacticas = jsonData['muestras_sintacticas'] ?? [];
      final List<dynamic> todas = [...lexicas, ...sintacticas];

      setState(() {
        _listaItemsPresentacion = todas
            .map((item) => ItemVocabulario.fromJson(item))
            // Filtramos la categoría y nos aseguramos de que tengan texto válido en ambos lados
            .where((item) => 
                (item.categoria ?? '').toLowerCase() == 'presentacion' &&
                item.espanol.isNotEmpty &&
                item.chol.isNotEmpty)
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar datos de presentación: $e');
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
          title: const Text('Cargando Presentación...', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    if (_listaItemsPresentacion.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            'No se pudieron cargar los datos de presentación.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
        ),
      );
    }

    return ActividadRelacionar(
      tituloActividad: 'Relacionar: Presentación',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItemsPresentacion,
    );
  }
}
