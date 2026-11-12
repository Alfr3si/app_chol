import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../../game_canvas/base_mapa_world.dart';

class PlayerComponent extends SpriteAnimationComponent
    with HasGameReference<BaseMapaWorld> {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runDownAnimation;
  late final SpriteAnimation runLeftAnimation;
  late final SpriteAnimation runRightAnimation;
  late final SpriteAnimation runUpAnimation;

  Vector2 velocity = Vector2.zero();
  final double speed = 120.0;
  String _lastState = '';

  // 🧱 Lista de obstáculos recibida dinámicamente desde el mapa activo
  final List<Rect> obstacles;

  PlayerComponent({required this.obstacles})
      : super(size: Vector2(64, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = await game.images.load('elements/spritesheet1.webp');
    final textureSize = Vector2(32, 32);

    idleAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.50,
        textureSize: textureSize,
        texturePosition: Vector2(0, 0),
        loop: true,
      ),
    );
    runDownAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.15,
        textureSize: textureSize,
        texturePosition: Vector2(0, 32),
        loop: true,
      ),
    );
    runLeftAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.15,
        textureSize: textureSize,
        texturePosition: Vector2(0, 128),
        loop: true,
      ),
    );
    runRightAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.15,
        textureSize: textureSize,
        texturePosition: Vector2(0, 96),
        loop: true,
      ),
    );
    runUpAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.15,
        textureSize: textureSize,
        texturePosition: Vector2(0, 64),
        loop: true,
      ),
    );

    animation = idleAnimation;
    _lastState = 'idle';
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!velocity.isZero()) {
      Vector2 nextPosition = position + velocity * dt;

      Rect playerRect = Rect.fromCenter(
        center: Offset(nextPosition.x, nextPosition.y),
        width: size.x * 0.7,
        height: size.y * 0.7,
      );

      bool hasCollision = false;
      for (final obstacle in obstacles) {
        if (obstacle.overlaps(playerRect)) {
          hasCollision = true;
          break;
        }
      }

      if (!hasCollision) {
        position = nextPosition;
      }

      // Límites del mapa (asumiendo mapas de 960x640)
      position.x = position.x.clamp(16.0, 960.0 - 16.0);
      position.y = position.y.clamp(16.0, 640.0 - 16.0);
    }
  }

  void move(String direction) {
    velocity.setZero();
    SpriteAnimation targetAnimation;
    String targetState;

    if (direction == 'down') {
      velocity.y = speed;
      targetAnimation = runDownAnimation;
      targetState = 'down';
    } else if (direction == 'up') {
      velocity.y = -speed;
      targetAnimation = runUpAnimation;
      targetState = 'up';
    } else if (direction == 'left') {
      velocity.x = -speed;
      targetAnimation = runLeftAnimation;
      targetState = 'left';
    } else if (direction == 'right') {
      velocity.x = speed;
      targetAnimation = runRightAnimation;
      targetState = 'right';
    } else {
      targetAnimation = idleAnimation;
      targetState = 'idle';
    }

    if (_lastState != targetState) {
      _lastState = targetState;
      animation = targetAnimation;
    }
  }

  void handleKeyEvent(Set<LogicalKeyboardKey> keysPressed) {
    final isDown =
        keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);
    final isUp =
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    final isLeft =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRight =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isDown) {
      move('down');
    } else if (isUp) {
      move('up');
    } else if (isLeft) {
      move('left');
    } else if (isRight) {
      move('right');
    } else {
      move('idle');
    }
  }
}
