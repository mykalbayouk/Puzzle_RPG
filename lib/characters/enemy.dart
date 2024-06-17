import 'package:flame/components.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/characters/person.dart';

class Enemy extends Person {
  Vector2 myPos;
  final double offNegX;
  final double offNegY;
  final double offPosX;
  final double offPosY;
  Enemy({
    required this.myPos, 
    this.offNegX = 0, 
    this.offNegY = 0,
    this.offPosX = 0,
    this.offPosY = 0,
    }) : 
    super(
      position: myPos,
      type: 'Characters', 
      name: 'FighterRed', 
      speed: 5
      );

  static const tileSize = 16.0;
  
  double rangeNegX = 0;
  double rangeNegY = 0;
  double rangePosX = 0;
  double rangePosY = 0;

  late final MainChar player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _calculateRange();    
    player = game.player;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _movement(dt);
  }

  void _movement(double dt) {
    double playerOffsetX = (player.scale.x > 0) ? 0 : -player.width;
    double playerOffsetY = (player.scale.y > 0) ? 0 : -player.height;
    if (playerInRange()) {
      print('player in range');
      if (player.position.x + playerOffsetX < position.x) {
        horizontalMovement += -1;
      } else if (player.position.x + playerOffsetX > position.x) {
        horizontalMovement += 1;
      } else {
        horizontalMovement = 0;
      }
      if (player.position.y + playerOffsetY < position.y) {
        verticalMovement += -1;
      } else if (player.position.y + playerOffsetY > position.y) {
        verticalMovement += 1;
      } else {
        verticalMovement = 0;
      }
    } else {
      horizontalMovement = 0;
      verticalMovement = 0;
    }
  }
  
  void _calculateRange() {
    rangeNegX = position.x - offNegX * tileSize;
    rangeNegY = position.y - offNegY * tileSize;
    rangePosX = position.x + offPosX * tileSize;
    rangePosY = position.y + offPosY * tileSize;
  }

  bool playerInRange() {
    return player.position.x >= rangeNegX &&
        player.position.x <= rangePosX &&
        player.position.y >= rangeNegY &&
        player.position.y <= rangePosY;
  }

}