// lib/modules/modulo1/actividades/actividad_familia_seleccion_imagen_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_seleccion_imagen.dart';

class ActividadFamiliaSeleccionImagenScreen extends StatefulWidget {
  const ActividadFamiliaSeleccionImagenScreen({super.key});

  @override
  State<ActividadFamiliaSeleccionImagenScreen> createState() => _ActividadFamiliaSeleccionImagenScreenState();
}

class _ActividadFamiliaSeleccionImagenScreenState extends State<ActividadFamiliaSeleccionImagenScreen> {
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

      final List<dynamic> muestras = jsonData['muestras_lexicas'] ?? [];

      setState(() {
        _listaItems = muestras
            .map((item) => ItemVocabulario.fromJson(item))
            .where((item) =>
                item.categoria == 'familia' &&
                item.chol.isNotEmpty &&
                item.espanol.isNotEmpty)
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar datos: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(backgroundColor: Colors.brown.shade800, title: const Text('Cargando...')),
        body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (_listaItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Aviso')),
        body: const Center(child: Text('No hay suficientes elementos de vocabulario.')),
      );
    }

    return ActividadSeleccionImagen(
      tituloActividad: 'Escucha y Selecciona la Imagen',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
