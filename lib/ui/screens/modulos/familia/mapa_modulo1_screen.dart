// lib/modules/modulo1/mapa_modulo1_screen.dart
import 'package:flutter/material.dart';

import '../../../core/base/base_mapa_screen.dart';

// Importa las pantallas usando los nombres exactos de tus archivos de actividades:
import './actividades/actividad_saludos_audio_screen.dart';
import './actividades/actividad_familia_relacionar_screen.dart';
import './actividades/actividad_familia_imagen_audio_screen.dart';
import './actividades/actividad_familia_seleccion_imagen_screen.dart';
import './actividades/actividad_memorama_screen.dart';
import './actividades/actividad_presentacion_relacionar_screen.dart';
import './actividades/actividad_tiempo_seleccion_imagen_screen.dart';

class MapaModulo1Screen extends StatelessWidget {
  const MapaModulo1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseMapaScreen(
      moduloId: 1,
      tituloModulo: 'Mi familia y yo',

      // 1. Fondo correspondiente a este mapa
      backgroundAsset: 'elements/mapa1.webp',

      // 2. Obstáculos y colisiones específicas del Módulo 1
      obstacles: const [
        Rect.fromLTWH(2.16155, 2.16155, 219.398, 125.37),
        Rect.fromLTWH(224.802, 2.16155, 731.686, 29.0286),
        Rect.fromLTWH(483.107, 47.5542, 123.209, 48.635),
        Rect.fromLTWH(706.828, 39.9887, 249.659, 87.5429),
        Rect.fromLTWH(897.045, 155.632, 56.2004, 446.361),
        Rect.fromLTWH(769.513, 244.256, 137.259, 109.158),
        Rect.fromLTWH(802.694, 469.057, 107.32, 103.755),
        Rect.fromLTWH(2.16155, 469.057, 156.713, 105.916),
        Rect.fromLTWH(2.16155, 565.246, 954.326, 73.4928),
        Rect.fromLTWH(3.24233, 128.612, 58.3619, 350.172),
        Rect.fromLTWH(65.9274, 212.913, 127.532, 109.158),
        Rect.fromLTWH(392.322, 246.417, 109.158, 105.916),
        Rect.fromLTWH(768.432, 470.138, 29.181, 38.908),
        Rect.fromLTWH(66.4672, 236.578, 100.264, 83.3656),
      ],

      // 3. Coordenadas de las casas / sensores de actividad
      casasRects: const [
        Rect.fromLTWH(120, 129.333, 30.0, 30.0), // ID 33
        Rect.fromLTWH(544, 98.6667, 30.0, 30.0), // ID 34
        Rect.fromLTWH(832, 129.333, 30.0, 30.0), // ID 35
        Rect.fromLTWH(833.333, 356, 30.0, 30.0), // ID 36
        Rect.fromLTWH(804, 552, 30.0, 30.0), // ID 37
        Rect.fromLTWH(160, 552, 30.0, 30.0), // ID 38
        Rect.fromLTWH(448, 353.333, 30.0, 30.0), // ID 39
        Rect.fromLTWH(120, 322.667, 30.0, 30.0), // ID 40
      ],

      // 4. Títulos de las casas que aparecerán en la ventana flotante
      houseNames: const [
        'Actividad 1',
        'Actividad 2',
        'Actividad 3',
        'Actividad 4',
        'Actividad 5',
        'Actividad 6',
        'Actividad 7',
        'Actividad 8',
      ],

      // 5. Enrutamiento hacia las pantallas de actividades de este módulo
      onNavigateToActivity: (activityName) {
        switch (activityName) {
          case 'Actividad 1':
          case 'Saludos':
            return const ActividadSaludosAudioScreen();

          case 'Actividad 2':
          case 'Mi Familia':
            return const ActividadFamiliaRelacionarScreen();

          case 'Actividad 3':
            return const ActividadVisualFamiliaScreen();

          case 'Actividad 4':
            return const ActividadFamiliaSeleccionImagenScreen();

          case 'Actividad 5':
            return const ActividadMemoramaScreen();

          case 'Actividad 6':
            return const ActividadPresentacionRelacionarScreen();

          case 'Actividad 7':
            return const ActividadTiempoSeleccionImagenScreen();

          case 'Actividad 8':
          default:
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.brown.shade800,
                title: Text(activityName, style: const TextStyle(color: Colors.white)),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(
                child: Text(
                  'Pantalla de $activityName en construcción',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
              ),
            );
        }
      },
    );
  }
}
