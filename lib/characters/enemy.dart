import 'dart:math';
import 'dart:ui';

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
      speed: 20,
      health: 50,
      );

  static const tileSize = 16.0;
  
  double rangeNegX = 0;
  double rangeNegY = 0;
  double rangePosX = 0;
  double rangePosY = 0;

  Vector2 spawnLocation = Vector2.zero();
  Vector2 currentTarget = Vector2.zero();
  bool movingToTarget = true; // true if moving to target, false if returning to spawn


  late final MainChar player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _calculateRange();    
    spawnLocation = position.clone(); // Assuming 'position' is the current position of the enemy
    player = game.player;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _movement(dt);
    _manageHealth();
  }

  void _movement(double dt) {
    if (!playerInRange()) {
      if (currentTarget == Vector2.zero() || _reachedTarget()) {
        if (movingToTarget) {
          currentTarget = _generateRandomPosition();
        } else {
          currentTarget = spawnLocation.clone();
        }
        movingToTarget = !movingToTarget; // Toggle the movement direction
      }
      moveToward(currentTarget, dt);
    } else {
      // Implement your attack logic here
      // TODO: Attack the player90
    }
  }

  bool _reachedTarget() {
    // Assuming there's a method to calculate the distance to the current target
    // and a small threshold to determine if the enemy has "reached" the target
    return position.distanceTo(currentTarget) < 1.0; // Example threshold
  }

  void moveToward(Vector2 target, double dt) {
    // Implement your movement logic here
    // This should move the enemy towards 'target' at a slow pace
    Vector2 direction = target - position;
    if (direction.length > 1) {
      direction.normalize();
      // Assuming there's a speed property that defines how fast the enemy moves
      position += direction * speed * dt;
    }
  }

  Vector2 _generateRandomPosition() {
    // Your existing method to generate a random position within the range
    double randomX = rangeNegX + (rangePosX - rangeNegX) * Random().nextDouble();
    double randomY = rangeNegY + (rangePosY - rangeNegY) * Random().nextDouble();
    return Vector2(randomX, randomY);
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
  
  void _manageHealth() {
    if (health <= 0) {
      // Implement your logic when the enemy's health reaches 0
      // This could include removing the enemy from the game
      // or playing a death animation
      removeFromParent();
    }
  }


}