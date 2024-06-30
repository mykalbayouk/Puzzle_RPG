import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:puzzle_rpg/characters/person.dart';
import 'package:puzzle_rpg/puz_rpg.dart';

class Exp extends SpriteComponent with HasGameRef<PuzRPG>, CollisionCallbacks{
  late double value;

  Exp({required Vector2 position, required this.value}) {
    this.position = position;
  }

  int canBounce = 0;


  @override
  Future<void> onLoad() async {
    _loadSprite();
    add(RectangleHitbox(
      size: Vector2(5, 5),
      position: Vector2(0, 0),
    ));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _bounce();
    super.update(dt);
  }

  void _bounce() {
    if (canBounce < 20) {
      position.y -= .1;
      canBounce++;
    } else if (canBounce < 40) {
      position.y += .1;
      canBounce++;
    } else {
      canBounce = 0;
    }
  }
  
  void _loadSprite() {
    sprite = Sprite(gameRef.images.fromCache('Items/Food/Seed2.png'));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Person) {
      gameRef.player.exp += value;
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}