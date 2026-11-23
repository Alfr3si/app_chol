// lib/modules/dondeVivo/actividades/actividad_casa_seleccion_imagen_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_seleccion_imagen.dart';

class ActividadCasaSeleccionImagenScreen extends StatefulWidget {
  final String categoriaFiltro;
  const ActividadCasaSeleccionImagenScreen({
    super.key,
    this.categoriaFiltro = 'casa',
  });

  @override
  State<ActividadCasaSeleccionImagenScreen> createState() =>
      _ActividadCasaSeleccionImagenScreenState();
}

class _ActividadCasaSeleccionImagenScreenState
    extends State<ActividadCasaSeleccionImagenScreen> {
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
          await rootBundle.loadString('assets/data/module_2_dondeVivo.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> muestras = jsonData['muestras_lexicas'] ?? [];

      // Filtro estricto: categoría 'casa' + texto válido en Ch'ol y Español + exclusión de traducciones faltantes + imagen obligatoria + audio obligatorio
      final filtrados = muestras
          .map((item) => ItemVocabulario.fromJson(item))
          .where((item) =>
              (item.categoria ?? '').trim().toLowerCase() ==
                  widget.categoriaFiltro.trim().toLowerCase() &&
              item.chol.trim().isNotEmpty &&
              item.chol.trim().toLowerCase() != 'no tiene traducción' &&
              item.espanol.trim().isNotEmpty &&
              item.pathImagen != null &&
              item.pathImagen!.trim().isNotEmpty &&
              item.pathAudio != null &&
              item.pathAudio!.trim().isNotEmpty);

      // Deduplicamos por palabra en Ch'ol para evitar duplicidades en la selección
      final Map<String, ItemVocabulario> unicosPorChol = {};
      for (var item in filtrados) {
        unicosPorChol.putIfAbsent(item.chol.trim().toLowerCase(), () => item);
      }

      setState(() {
        _listaItems = unicosPorChol.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(
          'Error al cargar datos de selección de imagen para la casa: $e');
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
          title: const Text('Cargando Casa...',
              style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
            child: CircularProgressIndicator(color: Colors.orange)),
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
              'No hay suficientes elementos con imagen, traducción y audio disponibles en esta categoría.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown),
            ),
          ),
        ),
      );
    }

    return ActividadSeleccionImagen(
      tituloActividad: 'Elige en casa',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaItems,
      moduloId: 2,
      actividadNumero: 2,
    );
  }
}
