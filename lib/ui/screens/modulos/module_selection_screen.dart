import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../../game_canvas/menu_game.dart'; // Ajusta la ruta si es necesario

class ModuleSelectionScreen extends StatefulWidget {
  const ModuleSelectionScreen({super.key});

  @override
  State<ModuleSelectionScreen> createState() => _ModuleSelectionScreenState();
}

class _ModuleSelectionScreenState extends State<ModuleSelectionScreen> {
  // Controlador para el PageView
  late final PageController _pageController;

  // Lista de módulos
  final List<Map<String, String>> _modulos = [
    {
      'id': 'modulo_1',
      'titulo': 'Módulo 1: Saludos',
      'tarjeta': 'assets/image/elements/marco_modulo1.webp',
      'imagen_modulo': 'assets/image/learning/grupo.webp',
    },
    {
      'id': 'modulo_2',
      'titulo': 'Módulo 2: Familia',
      'tarjeta': 'assets/image/elements/marco_modulos.webp',
      'imagen_modulo': 'assets/image/learning/grupo.webp',
    },
    {
      'id': 'modulo_3',
      'titulo': 'Módulo 3: Animales',
      'tarjeta': 'assets/image/elements/marco_modulos.webp',
      'imagen_modulo': 'assets/image/learning/grupo.webp',
    },
    {
      'id': 'modulo_4',
      'titulo': 'Módulo 4: Números',
      'tarjeta': 'assets/image/elements/marco_modulos.webp',
      'imagen_modulo': 'assets/image/learning/grupo.webp',
    },
    {
      'id': 'modulo_5',
      'titulo': 'Módulo 5: Objetos',
      'tarjeta': 'assets/image/elements/marco_modulos.webp',
      'imagen_modulo': 'assets/image/learning/grupo.webp',
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

  void _seleccionarModulo(String idModulo, String titulo) {
    debugPrint('Módulo seleccionado y abierto: $idModulo');
    // TODO: Navegar a la actividad específica del módulo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. FONDO ANIMADO DE FLAME (Estático y fluido sin parpadeos)
          GameWidget(game: MenuGame()),

          // 2. CONTENIDO PRINCIPAL
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // Título principal
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
                                      0.75,
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
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Stack(
                                                  children: [
                                                    // 1. MARCO / TARJETA BASE (.webp principal en el fondo de la card)
                                                    Positioned.fill(
                                                      child: Image.asset(
                                                        modulo['tarjeta']!,
                                                        fit: BoxFit.fill,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stack,
                                                        ) {
                                                          return Container(
                                                            color: Colors
                                                                .orangeAccent,
                                                            child: const Icon(
                                                              Icons.folder,
                                                              size: 60,
                                                              color: Colors
                                                                  .white,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    // 2. ILUSTRACIÓN TEMÁTICA INTERIOR (Reducida y adaptada al hueco)
                                                    Positioned(
                                                      top: 60,   // Margen superior ampliado para hacerla más chica
                                                      left: 10,  // Margen izquierdo ampliado
                                                      right:0, // Margen derecho ampliado
                                                      bottom: 28, // Margen inferior ampliado para dejar espacio al título
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          10,
                                                        ),
                                                        child: Image.asset(
                                                          modulo[
                                                              'imagen_modulo']!,
                                                          fit: BoxFit.contain, // Escala la imagen para que encaje completa sin recortarse
                                                          errorBuilder: (
                                                            context,
                                                            error,
                                                            stack,
                                                          ) {
                                                            return Container(
                                                              color: Colors
                                                                  .white10,
                                                              child:
                                                                  const Icon(
                                                                Icons.image,
                                                                size: 40,
                                                                color: Colors
                                                                    .white54,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),

                                                    // 3. TÍTULO DEL MÓDULO EN LA PARTE INFERIOR
                                                    Positioned(
                                                      bottom: 12,
                                                      left: 10,
                                                      right: 10,
                                                      child: Text(
                                                        modulo['titulo']!,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              offset:
                                                                  Offset(1, 1),
                                                              blurRadius: 3,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
