import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para rootBundle
import '../../../../../domain/models/item_vocabulario.dart';
import '../../components/actividad_generica_screen.dart';

class ActividadSaludosScreen extends StatefulWidget {
  const ActividadSaludosScreen({super.key});

  @override
  State<ActividadSaludosScreen> createState() => _ActividadSaludosScreenState();
}

class _ActividadSaludosScreenState extends State<ActividadSaludosScreen> {
  List<ItemVocabulario> _listaSaludos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosDesdeJson();
  }

  Future<void> _cargarDatosDesdeJson() async {
    try {
      // 1. Cargas el archivo JSON desde tus assets (ajusta la ruta según tengas tu archivo)
      final String jsonString = await rootBundle.loadString('assets/data/module_1_familia.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // 2. Extraes únicamente la sección de muestras léxicas o filtras los saludos
      final List<dynamic> muestras = jsonData['muestras_lexicas'] ?? [];

      // 3. Convertimos los primeros elementos correspondientes a saludos en ItemVocabulario
      // (Puedes filtrar por índices o por categoría según estructures tu JSON)
      setState(() {
        _listaSaludos = muestras.take(8).map((item) {
          return ItemVocabulario(
            espanol: item['espanol'] ?? '',
            chol: item['chol'] ?? '',
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar el JSON de saludos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si todavía está cargando el archivo, mostramos un indicador visual
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(
          backgroundColor: Colors.brown.shade800,
          title: const Text('Cargando Saludos...', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    // Si ocurrió algún error o está vacío
    if (_listaSaludos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No se pudieron cargar los datos de saludos.')),
      );
    }

    // Retornamos la pantalla genérica con los datos leídos del JSON
    return ActividadGenericaScreen(
      tituloActividad: 'Actividad 1: Saludos',
      backgroundImage: 'assets/image/learning/bg_casa_06.webp',
      listaItems: _listaSaludos,
    );
  }
}
