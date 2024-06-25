import 'package:flame/components.dart';
import 'package:puzzle_rpg/puz_rpg.dart';

class Weapon extends SpriteComponent with HasGameRef<PuzRPG> {
  late double attackTime;

  Weapon({required Vector2 position, required this.attackTime}) {
    attackTime = attackTime;
    this.position = position;
  }

  double ticker = 0;

  @override
  Future<void> onLoad() async {
    _loadSprite();
    debugMode = false;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    ticker += dt;
    if (ticker >= attackTime) {
      removeFromParent();
    }

    super.update(dt);
  }


  void _loadSprite() async{
        sprite = Sprite(gameRef.images.fromCache('Items/Weapons/Katana/SpriteInHand.png'));
    }
  }


