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
        width: 700, // Contenedor exterior del teléfono
        height: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundAsset),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            // --- PANTALLA INTERNA DEL TELÉFONO (Exactamente 353 x 209) ---
            Positioned(
              left: 173, // (700 - 353) / 2 si está centrada
              top: 95, // (400 - 209) / 2 si está centrada
              width: 353,
              height: 209,
              child: child,
            ),

            // --- BOTÓN DE CERRAR ---
            Positioned(
              top: 15,
              right: 25,
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
