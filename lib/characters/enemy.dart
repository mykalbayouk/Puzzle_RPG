import 'dart:math';

import 'package:flame/components.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/characters/person.dart';
import 'package:puzzle_rpg/tools/bar.dart';
import 'package:puzzle_rpg/tools/exp.dart';
import 'package:puzzle_rpg/utilities/util.dart';

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
  }) : super(
          position: myPos,
          type: 'Characters',
          name: 'SkeletonDemon',
          speed: 20,
          health: 50,
        );

  static const tileSize = 16.0;

  double speedAvg = 0;
  double speedPlayer = 0;

  double rangeNegX = 0;
  double rangeNegY = 0;
  double rangePosX = 0;
  double rangePosY = 0;

  Vector2 spawnLocation = Vector2.zero();
  Vector2 currentTarget = Vector2.zero();
  bool movingToTarget =
      true; // true if moving to target, false if returning to spawn

  late final MainChar player;

  bool attackPlayer = false;
  bool stopUpdating = false;

  double ticker = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _calculateRange();

    _loadHealthBar();
    spawnLocation = position
        .clone(); // Assuming 'position' is the current position of the enemy
    player = game.player;
    speedAvg = speed;
    speedPlayer = speed * 2;
  }

  @override
  void update(double dt) {
    if (!stopUpdating) { 
    super.update(dt);
    _movement(dt);
    _manageHealth();
    checkHorizontalCollisions(collisions);
    checkVerticalCollisions(collisions);
    _updateCanAttack();
    ticker += dt;
    }
  }

  @override
  void onRemove() {
    player.enemies.remove(this);
    stopUpdating = true;
    super.onRemove();
  }

  void _movement(double dt) {
    if (!playerInRange()) {
      speed = speedAvg;
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
      if (!checkCollision(this, player)) {
        speed = speedPlayer;
        moveToward(_outSidePlayerPos(), dt);
      } else {
        _attackPlayer();
      }
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
      isIdle = false;
      direction.normalize();
      // need to adjust the animation depending on the direction
      if (direction.x > 0 && direction.x.abs() > direction.y.abs()) {
        animation = walkRight;
        this.direction = Direction.right;
      } else if (direction.x < 0 && direction.x.abs() > direction.y.abs()) {
        animation = walkLeft;
        this.direction = Direction.left;
      } else if (direction.y > 0 && direction.y.abs() > direction.x.abs()) {
        animation = walkDown;
        this.direction = Direction.down;
      } else if (direction.y < 0 && direction.y.abs() > direction.x.abs()) {
        animation = walkUp;
        this.direction = Direction.up;
      }
      position += direction * speed * dt;
    }
  }

  Vector2 _generateRandomPosition() {
    // Your existing method to generate a random position within the range
    double randomX =
        rangeNegX + (rangePosX - rangeNegX) * Random().nextDouble();
    double randomY =
        rangeNegY + (rangePosY - rangeNegY) * Random().nextDouble();
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
      parent?.add(Exp(position: position, value: speedAvg/4));
      removeFromParent();
    }
  }

  Vector2 _outSidePlayerPos() {
    switch (direction) {
      case Direction.up:
        return Vector2(player.position.x, player.position.y - 1);
      case Direction.down:
        return Vector2(player.position.x, player.position.y + 1);
      case Direction.left:
        return Vector2(player.position.x - 1, player.position.y);
      case Direction.right:
        return Vector2(player.position.x + 1, player.position.y);
      default:
        return Vector2(player.position.x, player.position.y);
    }
  }

  void _attackPlayer() async {
    speed = 0;
    animation!.loop = false;
    SpriteAnimation ani;
    switch (direction) {
      case Direction.up:
        ani = attackUp;
        break;
      case Direction.down:
        ani = attackDown;
        break;
      case Direction.left:
        ani = attackLeft;
        break; 
      case Direction.right:
        ani = attackRight;
        break;
      default:
        ani = attackDown;
        break;
    }

    animation = ani;

    await animationTicker!.completed;

    if (checkCollision(this, player) && !attackPlayer) {
        player.health -= 1;
        attackPlayer = true;
    }
  }
  
  void _loadHealthBar() {
    add(Bar(position: Vector2(4,  -.5), char: this));
  }
  
  void _updateCanAttack() {
    if (ticker - 5 > 0) {
      ticker = 0;
      attackPlayer = false;
    }
  }
}
