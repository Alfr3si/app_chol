// lib/modules/modulo1/actividades/actividad_familia_relacionar_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_relacionar.dart';

class ActividadFamiliaRelacionarScreen extends StatefulWidget {
  const ActividadFamiliaRelacionarScreen({super.key});

  @override
  State<ActividadFamiliaRelacionarScreen> createState() => _ActividadFamiliaRelacionarScreenState();
}

class _ActividadFamiliaRelacionarScreenState extends State<ActividadFamiliaRelacionarScreen> {
  List<ItemVocabulario> _listaFamilia = [];
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

      final List<dynamic> muestras = jsonData['muestras_lexicas'] ?? [];

      setState(() {
        _listaFamilia = muestras
            .map((item) => ItemVocabulario.fromJson(item))
            // Filtro flexible para la categoría 'familia' asegurando texto válido
            .where((item) => 
                item.categoria == 'familia' && 
                item.chol.isNotEmpty && 
                item.espanol.isNotEmpty)
            .toList();
        
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar el JSON de familia: $e');
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
          title: const Text('Cargando Familia...', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    if (_listaFamilia.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No se pudieron cargar los datos de la familia.')),
      );
    }

    return ActividadRelacionar(
      tituloActividad: 'Actividad 2: Mi Familia',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaFamilia,
    );
  }
}
