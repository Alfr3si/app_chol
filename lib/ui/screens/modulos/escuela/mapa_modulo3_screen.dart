// lib/modules/modulo3/mapa_modulo3_screen.dart
import 'package:flutter/material.dart';
import '../../../core/base/base_mapa_screen.dart';

// Importa aquí las pantallas de tus actividades del Módulo 3:
// import './actividades/actividad_1_screen.dart';

class MapaModulo3Screen extends StatelessWidget {
  const MapaModulo3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMapaScreen(
      moduloId: 3,
      tituloModulo: 'Mi Escuela',
      
      // 1. Fondo correspondiente a este mapa
      backgroundAsset: 'elements/mapa3.webp',

      // 2. Obstáculos y colisiones específicas del Módulo 3 (extraídas del XML)
      obstacles: const [
        Rect.fromLTWH(2.25312, 2.25312, 953.072, 29.2906),
        Rect.fromLTWH(2.25312, 33.7969, 57.4547, 603.837),
        Rect.fromLTWH(63.0875, 33.7969, 121.669, 59.7078),
        Rect.fromLTWH(416.828, 33.2336, 188.136, 59.7078),
        Rect.fromLTWH(386.411, 32.107, 30.4169, 28.1641),
        Rect.fromLTWH(742.405, 33.2336, 212.92, 91.2515),
        Rect.fromLTWH(899.56, 127.865, 58.5809, 508.08),
        Rect.fromLTWH(63.0877, 564.971, 832.529, 72.1004),
        Rect.fromLTWH(288.963, 501.32, 315.437, 65.341),
        Rect.fromLTWH(354.867, 467.523, 153.212, 65.341),
        Rect.fromLTWH(604.964, 531.737, 31.5433, 65.341),
        Rect.fromLTWH(865.2, 466.397, 33.7964, 111.53),
        Rect.fromLTWH(834.783, 499.63, 33.7964, 111.53),
        Rect.fromLTWH(675.374, 274.318, 234.325, 45.0624),
        Rect.fromLTWH(738.462, 321.07, 210.667, 60.8343),
        Rect.fromLTWH(386.974, 210.667, 183.63, 108.15),
        Rect.fromLTWH(63.6506, 271.501, 187.01, 143.073),
      ],

      // 3. Coordenadas de las casas / sensores de actividad (5 puntos del XML)
      casasRects: const [
        Rect.fromLTWH(95.7578, 95.7578, 30.0, 30.0),   // ID 25
        Rect.fromLTWH(853.934, 128.428, 30.0, 30.0),  // ID 26
        Rect.fromLTWH(478.789, 321.07, 30.0, 30.0),   // ID 27
        Rect.fromLTWH(128.428, 417.955, 30.0, 30.0),  // ID 28
        Rect.fromLTWH(844.922, 385.284, 30.0, 30.0),  // ID 29
      ],

      // 4. Títulos de las casas que aparecerán en la ventana flotante
      houseNames: const [
        'Actividad 1',
        'Actividad 2',
        'Actividad 3',
        'Actividad 4',
        'Actividad 5',
      ],

      // 5. Enrutamiento hacia las pantallas de actividades de este módulo
      onNavigateToActivity: (activityName) {
        switch (activityName) {
          case 'Actividad 1':
            // return const Actividad1Screen();
          default:
            return Scaffold(
              appBar: AppBar(title: Text(activityName)),
              body: Center(child: Text('Pantalla de $activityName en construcción')),
            );
        }
      },
    );
  }
}
