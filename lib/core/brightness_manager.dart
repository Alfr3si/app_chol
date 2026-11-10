import 'package:flutter/material.dart';

class BrightnessManager extends ChangeNotifier {
  // Patrón Singleton para acceso global en toda la app
  static final BrightnessManager instance = BrightnessManager._internal();
  BrightnessManager._internal();

  // Valor por defecto del brillo (1.0 = 100% brillante)
  double _brightness = 1.0;
  
  double get brightness => _brightness;

  // Método para actualizar el brillo y notificar a los oyentes al instante
  void setBrightness(double newBrightness) {
    _brightness = newBrightness.clamp(0.2, 1.0); // Evitamos que baje de 0.2 para no oscurecer por completo
    notifyListeners(); // Esto avisa automáticamente a cualquier pantalla conectada para que se redibuje
    debugPrint('Brillo global actualizado a: ${(_brightness * 100).toInt()}%');
  }
}
