import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- 1. COMPONENTE DEL JUGADOR CON NUEVAS COLISIONES ---
class PlayerComponent extends SpriteAnimationComponent
    with HasGameReference<MapaModulo1World> {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runDownAnimation;
  late final SpriteAnimation runLeftAnimation;
  late final SpriteAnimation runRightAnimation;
  late final SpriteAnimation runUpAnimation;

  Vector2 velocity = Vector2.zero();
  final double speed = 120.0;
  String _lastState = '';

  // 🧱 Lista actualizada con tus nuevas coordenadas de colisión (Mapa 960x640)
  final List<Rect> obstacles = [
    const Rect.fromLTWH(2.16155, 2.16155, 219.398, 125.37),
    const Rect.fromLTWH(224.802, 2.16155, 731.686, 58.3619),
    const Rect.fromLTWH(483.107, 47.5542, 123.209, 48.635),
    const Rect.fromLTWH(706.828, 39.9887, 249.659, 87.5429),
    const Rect.fromLTWH(897.045, 155.632, 56.2004, 446.361),
    const Rect.fromLTWH(769.513, 244.256, 137.259, 109.158),
    const Rect.fromLTWH(798.694, 469.057, 111.32, 103.755),
    const Rect.fromLTWH(2.16155, 469.057, 156.713, 105.916),
    const Rect.fromLTWH(2.16155, 565.246, 954.326, 73.4928),
    const Rect.fromLTWH(3.24233, 128.612, 58.3619, 350.172),
    const Rect.fromLTWH(65.9274, 212.913, 127.532, 109.158),
    const Rect.fromLTWH(392.322, 246.417, 109.158, 105.916),
    const Rect.fromLTWH(768.432, 470.138, 29.181, 38.908),
  ];

  // 🟢 Personaje configurado a su tamaño real de 32x32 píxeles
  PlayerComponent() : super(size: Vector2(64, 64), anchor: Anchor.center);

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

      // 🔲 Hitbox proporcional a los 32x32
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

      // 🛑 Límites del mapa de 960x640 para el personaje de 32x32
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
    final isDown = keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);
    final isUp = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
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

// --- 2. EL MUNDO DE FLAME ---
class MapaModulo1World extends FlameGame with KeyboardEvents {
  late PlayerComponent player;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 1. Fondo de 960x640
    final background = SpriteComponent()
      ..sprite = await loadSprite('elements/mapa1.webp')
      ..size = Vector2(960, 640);
    world.add(background);

    // 2. Jugador ubicado en una zona libre fuera de las colisiones
    player = PlayerComponent()..position = Vector2(300, 420);
    world.add(player);

    // 3. Configuración de la cámara
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = 1.2;
    camera.follow(player);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    player.handleKeyEvent(keysPressed);
    return KeyEventResult.handled;
  }
}

// --- 3. WIDGET DE FLUTTER ---
class MapaModulo1Screen extends StatefulWidget {
  const MapaModulo1Screen({super.key});

  @override
  State<MapaModulo1Screen> createState() => _MapaModulo1ScreenState();
}

class _MapaModulo1ScreenState extends State<MapaModulo1Screen> {
  late final MapaModulo1World gameInstance;

  @override
  void initState() {
    super.initState();
    gameInstance = MapaModulo1World();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: gameInstance),

          // Botón de Regreso
          Positioned(
            top: 40,
            left: 20,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver a Módulos'),
            ),
          ),

          // D-Pad Táctil
          Positioned(
            bottom: 30,
            left: 30,
            child: SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTapDown: (_) => gameInstance.player.move('up'),
                      onTapUp: (_) => gameInstance.player.move('idle'),
                      onTapCancel: () => gameInstance.player.move('idle'),
                      child: _buildControlButton(Icons.arrow_drop_up),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTapDown: (_) => gameInstance.player.move('down'),
                      onTapUp: (_) => gameInstance.player.move('idle'),
                      onTapCancel: () => gameInstance.player.move('idle'),
                      child: _buildControlButton(Icons.arrow_drop_down),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTapDown: (_) => gameInstance.player.move('left'),
                      onTapUp: (_) => gameInstance.player.move('idle'),
                      onTapCancel: () => gameInstance.player.move('idle'),
                      child: _buildControlButton(Icons.arrow_left),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTapDown: (_) => gameInstance.player.move('right'),
                      onTapUp: (_) => gameInstance.player.move('idle'),
                      onTapCancel: () => gameInstance.player.move('idle'),
                      child: _buildControlButton(Icons.arrow_right),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black54,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white70, width: 2),
      ),
      child: Icon(icon, color: Colors.white, size: 32),
    );
  }
}
