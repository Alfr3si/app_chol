import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../../game_canvas/menu_game.dart';
import '../../../core/audio_manager.dart';
import 'module_carousel.dart';
import 'module_header.dart';
import './familia/mapa_modulo1_screen.dart';
import './dondeVivo/mapa_modulo2_screen.dart';
import './escuela/mapa_modulo3_screen.dart';
import './gustosYpasatiempos/mapa_modulo4_screen.dart';
import './miCuerpo/mapa_modulo5_screen.dart';

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

    Widget? pantallaDestino;

    // 1. Determinamos a qué pantalla navegar según el ID del módulo
    switch (idModulo) {
      case 'modulo_1':
        pantallaDestino = const MapaModulo1Screen();
        break;
      case 'modulo_2':
        pantallaDestino = const MapaModulo2Screen();
        break;
      case 'modulo_3':
        pantallaDestino = const MapaModulo3Screen();
        break;
      case 'modulo_4':
        pantallaDestino = const MapaModulo4Screen();
        break;
      case 'modulo_5':
        pantallaDestino = const MapaModulo5Screen();
        break;
    }
    // 2. Si el mapa ya está creado, ejecutamos la transición con manejo de audio
    if (pantallaDestino != null) {
      // Cortamos la música por completo antes de entrar al mapa
      AudioManager.instance.stopMusic();

      // Esperamos a que el usuario entre al mapa y regrese
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pantallaDestino!),
      );

      // Al regresar a esta pantalla, reiniciamos la música de selección
      await AudioManager.instance.playTrack('menu_principal.mp3', volume: 0.5);
    } else {
      // Si el módulo aún no tiene pantalla creada, muestra el aviso provisional
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Próximamente: $titulo')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. FONDO ANIMADO DE FLAME
          GameWidget(
            game: MenuGame(backgroundAsset: 'background/fondo_modulos.webp'),
          ),

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
