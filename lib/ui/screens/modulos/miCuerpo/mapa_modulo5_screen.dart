// lib/modules/modulo5/mapa_modulo5_screen.dart
import 'package:flutter/material.dart';
import '../../../core/base/base_mapa_screen.dart';

// Importa aquí las pantallas de tus actividades del Módulo 5:
// import './actividades/actividad_1_screen.dart';

class MapaModulo5Screen extends StatelessWidget {
  const MapaModulo5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMapaScreen(
      moduloId: 5,
      tituloModulo: 'Mi Cuerpo',
      
      // 1. Fondo correspondiente a este mapa
      backgroundAsset: 'elements/mapa5.webp',

      // 2. Obstáculos y colisiones específicas del Módulo 5 (extraídas del XML)
      obstacles: const [
        Rect.fromLTWH(1.12656, 1.12656, 219.68, 125.048),
        Rect.fromLTWH(353.741, 181.377, 250.097, 136.314),
        Rect.fromLTWH(705.791, 1.69005, 250.097, 125.048),
        Rect.fromLTWH(737.898, 178.56, 218.553, 138.567),
        Rect.fromLTWH(1.1266, 338.532, 189.262, 139.694),
        Rect.fromLTWH(223.059, 1.68986, 478.789, 30.4172),
        Rect.fromLTWH(2.81638, 126.738, 56.3282, 208.414),
        Rect.fromLTWH(3.37964, 480.479, 56.3282, 156.592),
        Rect.fromLTWH(161.661, 126.738, 58.5816, 32.6699),
        Rect.fromLTWH(61.9608, 563.844, 894.491, 73.2265),
        Rect.fromLTWH(898.997, 317.127, 56.3282, 252.35),
        Rect.fromLTWH(419.081, 434.29, 280.514, 136.314),
        Rect.fromLTWH(766.626, 498.504, 30.4172, 67.5937),
        Rect.fromLTWH(703.538, 468.087, 59.7078, 93.5046),
        Rect.fromLTWH(799.296, 529.484, 28.1641, 67.5937),
        Rect.fromLTWH(354.304, 500.194, 28.1641, 67.5937),
        Rect.fromLTWH(385.848, 472.03, 28.1641, 91.2515),
      ],

      // 3. Coordenadas de las casas / sensores de actividad (5 puntos del XML)
      casasRects: const [
        Rect.fromLTWH(119.416, 129.555, 30.0, 30.0),  // ID 18
        Rect.fromLTWH(831.403, 129.555, 30.0, 30.0),  // ID 19
        Rect.fromLTWH(855.061, 319.944, 30.0, 30.0),  // ID 20
        Rect.fromLTWH(481.042, 319.944, 30.0, 30.0),  // ID 21
        Rect.fromLTWH(95.7578, 479.916, 30.0, 30.0),  // ID 22
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
