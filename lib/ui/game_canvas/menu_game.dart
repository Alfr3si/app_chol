import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class MenuGame extends FlameGame {
  // Declaramos la variable para la ruta del fondo
  final String backgroundAsset;

  // Constructor que recibe la imagen (por defecto usa 'background/fondo1.webp')
  MenuGame({this.backgroundAsset = 'background/fondo1.webp'});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Usamos la variable en lugar de un texto fijo
    final bgFondo = await loadSprite(backgroundAsset);
    final bgComponent = SpriteComponent(
      sprite: bgFondo,
      size: size,
    );
    add(bgComponent);

    final nubesComponent = await ParallaxComponent.load(
      [
        ParallaxImageData('elements/nubes_tira.webp'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1, 1),
    );

    add(nubesComponent);
  }
}
