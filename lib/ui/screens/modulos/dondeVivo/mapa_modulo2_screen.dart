// lib/modules/modulo2/mapa_modulo2_screen.dart
import 'package:flutter/material.dart';
import '../../../core/base/base_mapa_screen.dart';

// Importa aquí las pantallas de tus actividades del Módulo 2:
// import './actividades/actividad_1_screen.dart';

class MapaModulo2Screen extends StatelessWidget {
  const MapaModulo2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMapaScreen(
      moduloId: 2,
      tituloModulo: 'El lugar donde vivo',
      
      // 1. Fondo correspondiente a este mapa
      backgroundAsset: 'elements/mapa2.webp',

      // 2. Obstáculos y colisiones específicas del Módulo 2 (extraídas del XML)
      obstacles: const [
        Rect.fromLTWH(4, 2.66667, 124, 280),
        Rect.fromLTWH(742, 3.33333, 53.3333, 186),
        Rect.fromLTWH(835.333, 3, 119.333, 93),
        Rect.fromLTWH(800.333, 160, 59.3333, 30),
        Rect.fromLTWH(790.333, 3, 59.3333, 26),
        Rect.fromLTWH(933.333, 98, 20.3333, 539),
        Rect.fromLTWH(802.833, 533.5, 90.3333, 103),
        Rect.fromLTWH(895.833, 440.5, 58.3333, 191),
        Rect.fromLTWH(866.833, 470, 32.3333, 80),
        Rect.fromLTWH(832.833, 502.5, 32.3333, 81),
        Rect.fromLTWH(4.83335, 468.5, 142.333, 131),
        Rect.fromLTWH(4.83335, 599, 769.333, 40),
        Rect.fromLTWH(769.5, 568, 83.6666, 42),
        Rect.fromLTWH(149.834, 468.5, 136.333, 44),
        Rect.fromLTWH(3.8335, 287, 23.333, 187),
        Rect.fromLTWH(130.334, 117.5, 56.333, 170),
        Rect.fromLTWH(189.167, 117.667, 64.333, 42.6667),
        Rect.fromLTWH(320.834, 245, 191.333, 44),
        Rect.fromLTWH(417.334, 279, 127.333, 44), // Corregido sin prefijos extra
        Rect.fromLTWH(419.334, 309, 153.333, 140.333),
        Rect.fromLTWH(515.333, 342, 150.666, 107.333),
        Rect.fromLTWH(419.333, 471, 90.333, 41),
        Rect.fromLTWH(578.833, 470.5, 89.333, 41),
        Rect.fromLTWH(609.667, 2.83333, 130, 91.6667),
      ],

      // 3. Coordenadas de las casas / sensores de actividad (6 puntos del XML)
      casasRects: const [
        Rect.fromLTWH(137.333, 81.3333, 30.0, 30.0),  // ID 28
        Rect.fromLTWH(664, 100, 30.0, 30.0),          // ID 29
        Rect.fromLTWH(886.667, 101.333, 30.0, 30.0),  // ID 30
        Rect.fromLTWH(541.333, 457.333, 30.0, 30.0),  // ID 31
        Rect.fromLTWH(88, 288, 30.0, 30.0),           // ID 32
        Rect.fromLTWH(150.667, 565.333, 30.0, 30.0),  // ID 33
      ],

      // 4. Títulos de las casas que aparecerán en la ventana flotante
      houseNames: const [
        'Actividad 1',
        'Actividad 2',
        'Actividad 3',
        'Actividad 4',
        'Actividad 5',
        'Actividad 6',
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
