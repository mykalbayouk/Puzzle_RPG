import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:puzzle_rpg/characters/person.dart';
import 'package:puzzle_rpg/puz_rpg.dart';


class Weapon extends SpriteComponent with HasGameRef<PuzRPG>, CollisionCallbacks  {
  late Person player;
  late String type;
  late int damage;

  Weapon({required Vector2 position, 
  required this.player,
  required this.type,
  required this.damage
  }) {
    player = player;
    type = type;
    damage = damage;
    this.position = position;
  }

  @override
  Future<void> onLoad() async {
    _loadSprite();
    add(RectangleHitbox());
    debugMode = false;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(player.isIdle){
      removeFromParent();
    }

    super.update(dt);
  }


  void _loadSprite() async{
        sprite = Sprite(gameRef.images.fromCache('Items/Weapons/$type/SpriteInHand.png'));
    }
  }


