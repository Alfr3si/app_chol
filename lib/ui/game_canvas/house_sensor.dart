// lib/game_canvas/components/house_sensor.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HouseSensorComponent extends PositionComponent {
  final String houseId;
  final String houseName;
  final Function(String houseName) onPlayerInRange;
  final Function() onPlayerOutRange;
  final Vector2 playerPositionRef; // Referencia a la posición del jugador

  bool _isPlayerInside = false;

  HouseSensorComponent({
    required Vector2 position,
    required Vector2 size,
    required this.houseId,
    required this.houseName,
    required this.onPlayerInRange,
    required this.onPlayerOutRange,
    required this.playerPositionRef,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);

    Rect houseRect = toRect();
    Rect playerRect = Rect.fromCenter(
      center: Offset(playerPositionRef.x, playerPositionRef.y),
      width: 64 * 0.7, // Ancho estimado del jugador
      height: 64 * 0.7,
    );

    bool overlapping = houseRect.overlaps(playerRect);

    if (overlapping && !_isPlayerInside) {
      _isPlayerInside = true;
      onPlayerInRange(houseName);
    } else if (!overlapping && _isPlayerInside) {
      _isPlayerInside = false;
      onPlayerOutRange();
    }
  }
}
