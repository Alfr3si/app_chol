import 'package:flutter/material.dart';

class FloatingChatBubble extends StatelessWidget {
  final String backgroundAsset;
  final Widget child;
  final VoidCallback onClose;

  const FloatingChatBubble({
    super.key,
    required this.backgroundAsset,
    required this.child,
    required this.onClose,
  });

  static void show(
    BuildContext context, {
    required String backgroundAsset,
    required Widget child,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar chat',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FloatingChatBubble(
          backgroundAsset: backgroundAsset,
          onClose: () => Navigator.of(context).pop(),
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 700, // Contenedor exterior del teléfono (Horizontal)
        height: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundAsset),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            // --- PANTALLA INTERNA DEL TELÉFONO (Área del chat ajustada para dejar espacio a la derecha) ---
            Positioned(
              left: 100,   // Margen izquierdo dentro del marco del teléfono
              top: 45,
              width: 500, // Ancho reducido para no invadir el espacio de los botones laterales
              height: 285,
              child: child,
            ),

            // --- 3 BOTONES LATERALES DERECHOS (Simulando la barra de navegación en horizontal) ---
            Positioned(
              right: 15,  // Distancia fija desde el borde derecho del contenedor del teléfono
              top: 45,    // Alineado con la parte superior de la pantalla interna
              bottom: 45, // Alineado con la parte inferior de la pantalla interna
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuye los 3 botones verticalmente
                children: [
                  // --- Botón 1: Superior ---
                  GestureDetector(
                    onTap: () {
                      debugPrint('Botón superior presionado (Cerrar chat)');
                      onClose();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/image/elements/button_telefono_salir.webp'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // --- Botón 2: Central (Más grande, como el botón principal) ---
                  GestureDetector(
                    onTap: () {
                      debugPrint('Botón central presionado (Cerrar chat)');
                      onClose();
                    },
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/image/elements/button_telefono_medio.webp'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // --- Botón 3: Inferior ---
                  GestureDetector(
                    onTap: () {
                      debugPrint('Botón inferior presionado (Cerrar chat)');
                      onClose();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/image/elements/button_telefono_3.webp'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
