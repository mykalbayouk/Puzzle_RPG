import 'package:puzzle_rpg/components/collision_block.dart';

class Mechanic extends CollisionBlock {

  bool isTriggered = false;

  Mechanic({
    required super.position,
    required super.size,
  });

  void trigger() {
    isTriggered = isTriggered ? false : true;
  }

  
}