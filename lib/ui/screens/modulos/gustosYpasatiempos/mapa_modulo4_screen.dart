// lib/modules/modulo4/mapa_modulo4_screen.dart
import 'package:flutter/material.dart';
import '../../../core/base/base_mapa_screen.dart';

// Importa aquí las pantallas de tus actividades del Módulo 4:
// import './actividades/actividad_1_screen.dart';

class MapaModulo4Screen extends StatelessWidget {
  const MapaModulo4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMapaScreen(
      moduloId: 4,
      tituloModulo: 'Gustos y Pasatiempos',
      
      // 1. Fondo correspondiente a este mapa
      backgroundAsset: 'elements/mapa4.webp',

      // 2. Obstáculos y colisiones específicas del Módulo 4 (extraídas del XML)
      obstacles: const [
        Rect.fromLTWH(226.439, 212.92, 728.886, 135.187),
        Rect.fromLTWH(705.791, 3.37985, 250.097, 123.922),
        Rect.fromLTWH(383.031, 1.12686, 224.186, 93.5041),
        Rect.fromLTWH(601.584, 2.81669, 122.795, 30.4166),
        Rect.fromLTWH(2.81635, 1.69013, 216.3, 91.251),
        Rect.fromLTWH(223.059, 2.81668, 158.845, 28.1635),
        Rect.fromLTWH(-0.563144, 563.845, 956.451, 73.226),
        Rect.fromLTWH(1.12654, 466.96, 90.125, 94.6307),
        Rect.fromLTWH(92.3781, 501.32, 31.5438, 94.6307),
        Rect.fromLTWH(128.991, 532.864, 29.2907, 94.6307),
        Rect.fromLTWH(800.986, 532.864, 155.466, 94.6307),
        Rect.fromLTWH(833.656, 501.32, 121.669, 94.6307),
        Rect.fromLTWH(897.87, 380.778, 58.5815, 94.6307),
        Rect.fromLTWH(864.073, 451.752, 90.1253, 94.6307),
        Rect.fromLTWH(1.12643, 91.2518, 58.5815, 377.398),
        Rect.fromLTWH(61.3976, 245.028, 63.0876, 105.896),
        Rect.fromLTWH(227.002, 350.361, 377.399, 30.4167),
        Rect.fromLTWH(736.208, 349.798, 61.9616, 31.5433),
        Rect.fromLTWH(706.354, 129.555, 55.2018, 25.9104),
        Rect.fromLTWH(900.686, 348.108, 55.2018, 36.0495),
        Rect.fromLTWH(899.56, 128.992, 55.2018, 82.2385),
      ],

      // 3. Coordenadas de las casas / sensores de actividad (5 puntos del XML)
      casasRects: const [
        Rect.fromLTWH(121.669, 95.7578, 30.0, 30.0),   // ID 30
        Rect.fromLTWH(503.573, 96.8844, 30.0, 30.0),  // ID 31
        Rect.fromLTWH(832.529, 129.555, 30.0, 30.0),  // ID 32
        Rect.fromLTWH(857.314, 350.361, 30.0, 30.0),  // ID 33
        Rect.fromLTWH(670.305, 350.361, 30.0, 30.0),  // ID 34
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
