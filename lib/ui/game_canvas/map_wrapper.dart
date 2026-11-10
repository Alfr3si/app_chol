import 'package:flame/components.dart';
import 'package:flame/game.dart';

class MapWrapper extends Component with HasGameReference<FlameGame> {
  final String imagePath;
  final double mapWidth;
  final double mapHeight;

  MapWrapper({
    this.imagePath = 'elements/fin_del_mapa.webp',
    this.mapWidth = 960.0,
    this.mapHeight = 640.0,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Cargamos la imagen utilizando game.images de forma moderna y limpia
    final wrapperImage = await game.images.load(imagePath);
    final sprite = Sprite(wrapperImage);

    // --- LADOS PRINCIPALES ---
    // Superior
    add(SpriteComponent()..sprite = sprite..position = Vector2(0, -mapHeight)..size = Vector2(mapWidth, mapHeight));
    // Inferior
    add(SpriteComponent()..sprite = sprite..position = Vector2(0, mapHeight)..size = Vector2(mapWidth, mapHeight));
    // Izquierdo
    add(SpriteComponent()..sprite = sprite..position = Vector2(-mapWidth, 0)..size = Vector2(mapWidth, mapHeight));
    // Derecho
    add(SpriteComponent()..sprite = sprite..position = Vector2(mapWidth, 0)..size = Vector2(mapWidth, mapHeight));

    // --- ESQUINAS DIAGONALES ---
    // Superior Izquierda
    add(SpriteComponent()..sprite = sprite..position = Vector2(-mapWidth, -mapHeight)..size = Vector2(mapWidth, mapHeight));
    // Superior Derecha
    add(SpriteComponent()..sprite = sprite..position = Vector2(mapWidth, -mapHeight)..size = Vector2(mapWidth, mapHeight));
    // Inferior Izquierda
    add(SpriteComponent()..sprite = sprite..position = Vector2(-mapWidth, mapHeight)..size = Vector2(mapWidth, mapHeight));
    // Inferior Derecha
    add(SpriteComponent()..sprite = sprite..position = Vector2(mapWidth, mapHeight)..size = Vector2(mapWidth, mapHeight));
  }
}
