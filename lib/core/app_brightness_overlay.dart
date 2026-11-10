import 'package:flutter/material.dart';
import './brightness_manager.dart';

class AppBrightnessOverlay extends StatelessWidget {
  final Widget child;

  const AppBrightnessOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: BrightnessManager.instance,
      builder: (context, _) {
        return Stack(
          children: [
            child,
            IgnorePointer(
              child: Container(
                color: Colors.black.withOpacity(
                  1.0 - BrightnessManager.instance.brightness,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
