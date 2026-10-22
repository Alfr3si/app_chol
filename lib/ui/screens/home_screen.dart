import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../game_canvas/menu_game.dart';
import '../core/widgets/animated_floating_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fondo del juego de Flame
          GameWidget(game: MenuGame()),

          // 2. Capa superior con SafeArea
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // <--- Esto distribuye y separa uniformemente
                  children: [
                    // --- 1. Perfil ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/images/elements/button_perfil.webp',
                      size: 120,
                      onTap: () {
                        debugPrint('Perfil presionado');
                      },
                    ),

                    // --- 2. Ajustes ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/images/elements/button_ajustes.webp',
                      size: 120,
                      onTap: () {
                        debugPrint('Ajustes presionado');
                      },
                    ),

                    // --- 3. Comenzar (Centro) ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/images/elements/button_comenzar.webp',
                      size: 120, // Destacado
                      onTap: () {
                        debugPrint('Comenzar presionado');
                      },
                    ),

                    // --- 4. Explora ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/images/elements/button_explora.webp',
                      size: 120,
                      onTap: () {
                        debugPrint('Explora presionado');
                      },
                    ),

                    // --- 5. Chatbot ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/images/elements/button_chatbot.webp',
                      size: 120,
                      onTap: () {
                        debugPrint('Chatbot presionado');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
