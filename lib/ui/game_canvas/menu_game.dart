import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class MenuGame extends FlameGame {
    @override
    Future<void> onLoad() async {
        super.onLoad();

        final bgFondo1 = await loadSprite('fondos/fondo1.webp');
        final bgComponent = SpriteComponent(
        sprite: bgFondo1,
        size: size,
        );
        add(bgComponent);

        final nubesComponent = await ParallaxComponent.load([
        //NOTE:esto se ve bien para alguna funcion
        // que quiero implementar despues
        // ParallaxImageData('fondos/fondo1.webp'),
        ParallaxImageData('elementos/nubes_tira.webp'),
        ],
        baseVelocity: Vector2(10, 0),
        velocityMultiplierDelta: Vector2(1, 1),
        );

        add(nubesComponent);
        }
    }
