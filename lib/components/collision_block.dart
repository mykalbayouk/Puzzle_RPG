import 'package:flame/components.dart';


/// A block that can be collided with, used for collision detection
class CollisionBlock extends PositionComponent {
  CollisionBlock({
    required Vector2 position,
    required Vector2 size,
  }) {
    this.position = position;
    this.size = size;
  }


}