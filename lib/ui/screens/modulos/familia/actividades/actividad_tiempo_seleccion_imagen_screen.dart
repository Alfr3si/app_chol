// lib/modules/modulo1/actividades/actividad_tiempo_seleccion_imagen_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_seleccion_imagen.dart';

class ActividadTiempoSeleccionImagenScreen extends StatefulWidget {
  final String categoriaFiltro;
  const ActividadTiempoSeleccionImagenScreen({super.key, this.categoriaFiltro = 'tiempo'});

  @override
  State<ActividadTiempoSeleccionImagenScreen> createState() => _ActividadTiempoSeleccionImagenScreenState();
}

class _ActividadTiempoSeleccionImagenScreenState extends State<ActividadTiempoSeleccionImagenScreen> {
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
            // Filtro estricto: categoría tiempo + texto válido + imagen y audio obligatorios (Mañana, Tarde, Noche)
            .where((item) =>
                item.categoria == widget.categoriaFiltro &&
                item.chol.isNotEmpty &&
                item.espanol.isNotEmpty &&
                item.pathImagen != null &&
                item.pathImagen!.isNotEmpty &&
                item.pathAudio != null &&
                item.pathAudio!.isNotEmpty)
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar datos de tiempo: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(backgroundColor: Colors.brown.shade800, title: const Text('Cargando tiempo...')),
        body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (_listaItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text('Aviso'),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay elementos de tiempo con imagen y audio disponibles.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
          ),
        ),
      );
    }

    return ActividadSeleccionImagen(
      tituloActividad: 'Actividad 7: Tiempo',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
    );
  }
}
