import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../game_canvas/menu_game.dart'; // Ajusta la ruta si es necesario
import '../../../core/audio_manager.dart';
import './familia/mapa_modulo1.dart';

class ModuleSelectionScreen extends StatefulWidget {
  const ModuleSelectionScreen({super.key});

  @override
  State<ModuleSelectionScreen> createState() => _ModuleSelectionScreenState();
}

class _ModuleSelectionScreenState extends State<ModuleSelectionScreen> {
  // Controlador para el PageView
  late final PageController _pageController;

  // Lista de módulos (Cada uno usa su marco limpio como única imagen de fondo de tarjeta)
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

                // Cabecera con Título y Botón de Regreso a la derecha
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Título principal centrado de forma absoluta
                      const Text(
                        'SELECCIONA UN MÓDULO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 6,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                      
                      // Botón de Regreso alineado a la derecha
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Regresa a la pantalla anterior (HomeScreen)
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                'assets/image/elements/button_x.webp',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) {
                                  return Container(
                                    color: Colors.orange,
                                    child: const Icon(Icons.arrow_back, color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // ANIMATED BUILDER: Aísla el movimiento solo para el carrusel
                Expanded(
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double currentPageValue = 0.0;
                      if (_pageController.hasClients &&
                          _pageController.position.haveDimensions) {
                        currentPageValue = _pageController.page ?? 0.0;
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                height: 340,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: _modulos.length,
                                  itemBuilder: (context, index) {
                                    // Cálculo de escala para la tarjeta central y laterales
                                    double scale = max(
                                      0.85,
                                      (1.0 -
                                          (currentPageValue - index).abs() *
                                              0.25),
                                    );

                                    // Efecto flotante vertical
                                    double translateY =
                                        (currentPageValue - index).abs() * 15.0;

                                    final modulo = _modulos[index];
                                    final bool isCurrent =
                                        (index == currentPageValue.round());

                                    return Center(
                                      child: Transform.translate(
                                        offset: Offset(0, translateY),
                                        child: Transform.scale(
                                          scale: scale,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!isCurrent) {
                                                _pageController.animateToPage(
                                                  index,
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                );
                                              } else {
                                                _seleccionarModulo(
                                                  modulo['id']!,
                                                  modulo['titulo']!,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 446,
                                              height: 252,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                // Única imagen de fondo para la tarjeta del módulo
                                                image: DecorationImage(
                                                  image: AssetImage(modulo['tarjeta']!),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              // Aquí puedes poner opcionalmente un texto o icono centrado si lo requieres dentro de la tarjeta
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Indicador visual de puntos dinámico
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _modulos.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 15,
                                ),
                                width: (currentPageValue.round() == index)
                                    ? 14
                                    : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: (currentPageValue.round() == index)
                                      ? Colors.orange
                                      : Colors.white54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
