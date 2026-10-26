import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../game_canvas/menu_game.dart';
import '../core/widgets/animated_floating_button.dart';
import './chat_ai/floating_chat_bubble.dart';
import './chat_ai/chatbot_content.dart';
import './modulos/module_selection_screen.dart';

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
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // <--- Esto distribuye y separa uniformemente
                  children: [
                    // --- 1. Perfil ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/image/elements/button_perfil.webp',
                      size: 140,
                      onTap: () {
                        debugPrint('Perfil presionado');
                      },
                    ),

                    // --- 2. Ajustes ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/image/elements/button_ajustes.webp',
                      size: 140,
                      onTap: () {
                        debugPrint('Ajustes presionado');
                      },
                    ),

                    // --- 3. Comenzar (Centro) ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/image/elements/button_comenzar.webp',
                      size: 140, // Destacado
                      onTap: () {
                        debugPrint('Comenzar presionado');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ModuleSelectionScreen(),
                          ),
                        );
                      },
                    ),

                    // --- 4. Explora ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/image/elements/button_explora.webp',
                      size: 140,
                      onTap: () {
                        debugPrint('Explora presionado');
                      },
                    ),

                    // --- 5. Chatbot (Aquí conectamos la ventana flotante) ---
                    AnimatedFloatingButton(
                      assetPath: 'assets/image/elements/button_chatbot.webp',
                      size: 120,
                      onTap: () {
                        // Al tocar el botón, abrimos el teléfono flotante con el chat adentro
                        FloatingChatBubble.show(
                          context,
                          backgroundAsset: 'assets/image/background/fondo_telefono.webp', // Tu imagen base del teléfono
                          child: const ChatbotContent(), // La lógica y los mensajes del chat
                        );
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
