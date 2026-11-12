import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../game_canvas/menu_game.dart'; // Ajusta la ruta si es necesario
import '../../../core/audio_manager.dart';
import './familia/mapa_modulo1_screen.dart';
import 'module_carousel.dart';
import 'module_header.dart';

class ModuleSelectionScreen extends StatefulWidget {
  const ModuleSelectionScreen({super.key});

  @override
  State<ModuleSelectionScreen> createState() => _ModuleSelectionScreenState();
}

class _ModuleSelectionScreenState extends State<ModuleSelectionScreen> {
  // Controlador para el PageView
  late final PageController _pageController;

  // Lista de módulos con tu formato original exacto
  final List<Map<String, String>> _modulos = [
    {
      'id': 'modulo_1',
      'titulo': 'Módulo 1: Saludos',
      'tarjeta': 'assets/image/learning/modulo1.webp',
    },
    {
      'id': 'modulo_2',
      'titulo': 'Módulo 2: Familia',
      'tarjeta': 'assets/image/learning/modulo2.webp',
    },
    {
      'id': 'modulo_3',
      'titulo': 'Módulo 3: Animales',
      'tarjeta': 'assets/image/learning/modulo3.webp',
    },
    {
      'id': 'modulo_4',
      'titulo': 'Módulo 4: Números',
      'tarjeta': 'assets/image/learning/modulo4.webp',
    },
    {
      'id': 'modulo_5',
      'titulo': 'Módulo 5: Objetos',
      'tarjeta': 'assets/image/learning/modulo5.webp',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.55, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarModulo(String idModulo, String titulo) async {
    debugPrint('Módulo seleccionado y abierto: $idModulo');
    
    if (idModulo == 'modulo_1') {
      // 1. Cortamos la música por completo antes de entrar al mapa del módulo 1
      AudioManager.instance.stopMusic();

      // 2. Esperamos a que el usuario entre al mapa y regrese
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapaModulo1Screen()),
      );

      // 3. AL REGRESAR A ESTA PANTALLA: La música de selección se reinicia desde el inicio
      await AudioManager.instance.playTrack('menu_principal.mp3', volume: 0.5);
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Próximamente: $titulo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. FONDO ANIMADO DE FLAME
          GameWidget(game: MenuGame(backgroundAsset: 'background/fondo_modulos.webp')),

          // 2. CONTENIDO PRINCIPAL
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Cabecera modularizada
                const ModuleHeader(),

                const SizedBox(height: 15),

                // Carrusel modularizado
                Expanded(
                  child: ModuleCarousel(
                    pageController: _pageController,
                    modulos: _modulos,
                    onModuloSelected: _seleccionarModulo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
