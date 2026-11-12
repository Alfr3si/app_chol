// lib/game_canvas/base_mapa_world.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/base/player_component.dart';
import 'map_wrapper.dart';
import 'house_sensor.dart';

class BaseMapaWorld extends FlameGame with KeyboardEvents {
  late PlayerComponent player;

  final String backgroundAsset;
  final List<Rect> casasRects;
  final List<String> houseNames;
  final List<Rect> obstacles;
  final Function(String) onHouseEntered;
  final Function() onHouseExited;

  BaseMapaWorld({
    required this.backgroundAsset,
    required this.casasRects,
    required this.houseNames,
    required this.obstacles,
    required this.onHouseEntered,
    required this.onHouseExited,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 0. Límites del mapa
    world.add(MapWrapper());

    // 1. Fondo dinámico
    final background = SpriteComponent()
      ..sprite = await loadSprite(backgroundAsset)
      ..size = Vector2(960, 640);
    world.add(background);

    // 2. Jugador (pasándole los obstáculos específicos de este mapa)
    player = PlayerComponent(obstacles: obstacles)..position = Vector2(300, 420);
    world.add(player);

    // 3. Zonas de actividades / casas dinámicas
    for (int i = 0; i < casasRects.length; i++) {
      final rect = casasRects[i];
      final houseSensor = HouseSensorComponent(
        position: Vector2(rect.left, rect.top),
        size: Vector2(rect.width, rect.height),
        houseId: 'casa_$i',
        houseName: houseNames[i],
        playerPositionRef: player.position,
        onPlayerInRange: (name) => onHouseEntered(name),
        onPlayerOutRange: () => onHouseExited(),
      );
      world.add(houseSensor);
    }

    // 4. Cámara
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = 1.2;
    camera.follow(player);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    player.handleKeyEvent(keysPressed);
    return KeyEventResult.handled;
  }
}
