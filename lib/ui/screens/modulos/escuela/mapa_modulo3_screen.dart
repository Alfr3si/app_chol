// lib/modules/modulo3/mapa_modulo3_screen.dart
import 'package:flutter/material.dart';
import '../../../core/base/base_mapa_screen.dart';

// Importación de las 5 actividades del Módulo 3 por categoría
import 'actividades/actividad_oficios_imagen_audio_screen.dart'; // Actividad 1
import 'actividades/actividad_utiles_seleccion_imagen_screen.dart'; // Actividad 2
import 'actividades/actividad_numeros_audio_screen.dart'; // Actividad 3
import 'actividades/actividad_memorama_screen.dart'; // Actividad 4
import 'actividades/actividad_acciones_relacionar_screen.dart'; // Actividad 5

class MapaModulo3Screen extends StatelessWidget {
  const MapaModulo3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMapaScreen(
      moduloId: 3,
      tituloModulo: 'Mi Escuela',

      // 1. Fondo correspondiente a este mapa
      backgroundAsset: 'elements/mapa3.webp',

      // 2. Obstáculos y colisiones específicas del Módulo 3
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
        Rect.fromLTWH(95.7578, 95.7578, 30.0, 30.0), // ID 25 (Actividad 1)
        Rect.fromLTWH(853.934, 128.428, 30.0, 30.0), // ID 26 (Actividad 2)
        Rect.fromLTWH(478.789, 321.07, 30.0, 30.0), // ID 27 (Actividad 3)
        Rect.fromLTWH(128.428, 417.955, 30.0, 30.0), // ID 28 (Actividad 4)
        Rect.fromLTWH(844.922, 385.284, 30.0, 30.0), // ID 29 (Actividad 5)
      ],

      // 4. Títulos coherentes para la ventana flotante
      houseNames: const [
        'Conoce oficios',
        'Elige útiles',
        'Escucha números',
        'Juega memorama',
        'Une acciones',
      ],

      // 5. Enrutamiento hacia las pantallas de actividades de este módulo
      onNavigateToActivity: (activityName) {
        switch (activityName) {
          case 'Conoce oficios':
          case 'Actividad 1':
            return const ActividadOficiosImagenAudioScreen();
          case 'Elige útiles':
          case 'Actividad 2':
            return const ActividadUtilesSeleccionImagenScreen();
          case 'Escucha números':
          case 'Actividad 3':
            return const ActividadNumerosAudioScreen();
          case 'Juega memorama':
          case 'Actividad 4':
            return const ActividadMemoramaScreen();
          case 'Une acciones':
          case 'Actividad 5':
            return const ActividadAccionesRelacionarScreen();
          default:
            return Scaffold(
              appBar: AppBar(title: Text(activityName)),
              body: Center(
                child: Text('Pantalla de $activityName en construcción'),
              ),
            );
        }
      },
    );
  }
}
