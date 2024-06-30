import 'package:flame/components.dart';
import 'package:puzzle_rpg/puz_rpg.dart';

class Hearts extends SpriteComponent with HasGameRef<PuzRPG>{
  
  Hearts({required Vector2 position}) {
    this.position = position;
  }

  late Sprite fullHeart;
  late Sprite tFHeart;
  late Sprite halfHeart;
  late Sprite oFHeart;
  late Sprite emptyHeart;

  @override
  Future<void> onLoad() async {
    _loadSprite();
    return super.onLoad();
  }

  void _loadSprite() {
    fullHeart = Sprite(
      gameRef.images.fromCache('Ui/Health/heart.png'),
      srcPosition: Vector2(64, 0),
      srcSize: Vector2(16, 16),
    );

    tFHeart = Sprite(
      gameRef.images.fromCache('Ui/Health/heart.png'),
      srcPosition: Vector2(48, 0),
      srcSize: Vector2(16, 16),
    );

    halfHeart = Sprite(
      gameRef.images.fromCache('Ui/Health/heart.png'),
      srcPosition: Vector2(32, 0),
      srcSize: Vector2(16, 16),
    );

    oFHeart = Sprite(
      gameRef.images.fromCache('Ui/Health/heart.png'),
      srcPosition: Vector2(16, 0),
      srcSize: Vector2(16, 16),
    );

    emptyHeart = Sprite(
      gameRef.images.fromCache('Ui/Health/heart.png'),
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(16, 16),
    );
    sprite = fullHeart;
  }

  void updateHeart(int health) {
    if (health == 0) {
      sprite = emptyHeart;
    } else if (health == 1) {
      sprite = oFHeart;
    } else if (health == 2) {
      sprite = halfHeart;
    } else if (health == 3) {
      sprite = tFHeart;
    } else if (health == 4) {
      sprite = fullHeart;
    }
  }

  
}