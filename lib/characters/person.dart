import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_rpg/components/collision_block.dart';
import 'package:puzzle_rpg/components/player_hitbox.dart';
import 'package:puzzle_rpg/tools/weapon.dart';
import 'package:puzzle_rpg/puz_rpg.dart';
import 'package:puzzle_rpg/utilities/util.dart';

enum PlayerState { idle, walk, attack }

enum Direction { up, down, left, right }

enum CollisionSide { top, bottom, left, right, none }

/// The parent class for all characters in the game
class Person extends SpriteAnimationComponent
    with HasGameRef<PuzRPG>, CollisionCallbacks {
  String type;
  String name;
  double speed;
  double health;
  Person(
      {super.position,
      required this.type,
      required this.name,
      required this.speed,
      required this.health});

  // Animations
  late final SpriteAnimation idleUp;
  late final SpriteAnimation walkUp;
  late final SpriteAnimation attackUp;

  late final SpriteAnimation idleDown;
  late final SpriteAnimation walkDown;
  late final SpriteAnimation attackDown;

  late final SpriteAnimation idleLeft;
  late final SpriteAnimation walkLeft;
  late final SpriteAnimation attackLeft;

  late final SpriteAnimation idleRight;
  late final SpriteAnimation walkRight;
  late final SpriteAnimation attackRight;

  late final SpriteAnimation interact;

  bool isIdle = true;
  Direction direction = Direction.down;

  bool isAttacking = false;
  bool isBeingAttacked = false;

  // animations update speed
  final double stepTime = .1;

  double horizontalMovement = 0;
  double verticalMovement = 0;
  late double moveSpeed;
  Vector2 velocity = Vector2.zero();
  late LogicalKeyboardKey priorityKey;

  List<CollisionBlock> collisions = [];

  //damage of the weapon this character wields
  int weaponDamage = 30;


  PlayerHitbox hitbox =
      PlayerHitbox(offsetX: 1, offsetY: 1, width: 14, height: 14);

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();

    moveSpeed = speed;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));

    priority = 1;

    debugMode = false;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!isAttacking) _updatePlayerMovement(dt);
    if (isBeingAttacked) _personFlash(dt);
    _updateAttack();
    checkHorizontalCollisions(collisions);    
    checkVerticalCollisions(collisions);
    super.update(dt);
  }

  /// Load all animations for the character based on the type and name
  void _loadAllAnimations() {
    // Load all animations
    idleUp = _createAnimation(type, name, 'Idle', 1, 16);
    walkUp = _createAnimation(type, name, 'Walk', 4, 16);
    attackUp = _createAnimation(type, name, 'Attack', 1, 16);

    idleDown = _createAnimation(type, name, 'Idle', 1, 0);
    walkDown = _createAnimation(type, name, 'Walk', 4, 0);
    attackDown = _createAnimation(type, name, 'Attack', 1, 0);

    idleLeft = _createAnimation(type, name, 'Idle', 1, 32);
    walkLeft = _createAnimation(type, name, 'Walk', 4, 32);
    attackLeft = _createAnimation(type, name, 'Attack', 1, 32);

    idleRight = _createAnimation(type, name, 'Idle', 1, 48);
    walkRight = _createAnimation(type, name, 'Walk', 4, 48);
    attackRight = _createAnimation(type, name, 'Attack', 1, 48);

    interact = _createAnimation(type, name, 'Special2', 1, 0);
  }

  /// Create an animation based on the type, name, description, amount, and start
  SpriteAnimation _createAnimation(
      String type, String name, String descrip, int amount, double start) {
    String dir = 'Actor/$type/$name/SeparateAnim/$descrip.png';
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(dir),
      SpriteAnimationData.sequenced(
        amountPerRow: 1,
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(16, 16),
        texturePosition: Vector2(start, 0),
        loop: true,
      ),
    );
  }

  /// update the player's movement based on either user or ai input
  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    velocity.y = verticalMovement * moveSpeed;
    if (velocity.y < 0 && velocity.y.abs() > velocity.x.abs()){
      animation = walkUp;
      direction = Direction.up;
    } else if (velocity.y > 0 && velocity.y.abs() > velocity.x.abs()){
      animation = walkDown;
      direction = Direction.down;
    } else if (velocity.x < 0 && velocity.x.abs() > velocity.y.abs()){
      animation = walkLeft;
      direction = Direction.left;
    } else if (velocity.x > 0 && velocity.x.abs() > velocity.y.abs()){
      animation = walkRight;
      direction = Direction.right;
    } else if (isIdle) {
      switch (direction) {
        case Direction.up:
          animation = idleUp;
          break;
        case Direction.down:
          animation = idleDown;
          break;
        case Direction.left:
          animation = idleLeft;
          break;
        case Direction.right:
          animation = idleRight;
          break;
      }
    }

    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  } 


  /// Update the attack animation based on the direction
  void _updateAttack() {
    if (isAttacking) {
      switch (direction) {
        case Direction.up:
          _attack(0);
          animation = attackUp;
          break;
        case Direction.down:
          _attack(1);
          animation = attackDown;
          break;
        case Direction.left:
          _attack(2);
          animation = attackLeft;
          break;
        case Direction.right:
          _attack(3);
          animation = attackRight;
          break;
      }
      isAttacking = false;
    }
  }

  /// Attack in a direction based on the direction
  /// 0 - up, 1 - down, 2 - left, 3 - right
  /// The weapon will be created in the direction of the player  
  void _attack(int direction) {
    // TODO: To be changed so weapon is not hard coded
    Weapon weapon;
    weapon = Weapon(
        position: _newDistance(direction),
        player: this,
        type: 'Katana',
        damage: weaponDamage);
    switch (direction) {
      case 0:
        weapon.scale.y = -1;
        break;
      case 1:
        weapon.scale.y = 1;
        break;
      case 2:
        weapon.scale.x = -1;
        weapon.transform.angle = pi / 2;
        break;
      case 3:
        weapon.scale.x = 1;
        weapon.transform.angle = pi * 3 / 2;
        break;
    }
    add(weapon);
  }

  /// Decides where weapon should spawn based on diretion of player
  Vector2 _newDistance(int direction) {
    switch (direction) {
      case 0:
        return Vector2(2, 0);
      case 1:
        return Vector2(2, 17);
      case 2:
        return Vector2(0, 16);
      case 3:
        return Vector2(17, 16);
      default:
        return Vector2.zero();
    }
  }

/// Check for collisions in the vertical direction
  void checkVerticalCollisions(coll) {
    for (final collision in coll) {
      if (checkCollision(this, collision)) {
        if (velocity.y > 0) {
          if (velocity.x == 0) {
            position.y = collision.position.y - hitbox.offsetY - hitbox.height;
          } else {
            handleDiagonalPosition(collision);
            break;
          }
        } else if (velocity.y < 0) {
          if (velocity.x == 0) {
            position.y = collision.position.y + collision.size.y;
          } else {
            handleDiagonalPosition(collision);
            break;
          }
        }
        velocity.y = 0;
        break;
      }
    }
  }
/// Check for collisions in the horizontal direction
  void checkHorizontalCollisions(coll) {
    for (final collision in coll) {
      if (checkCollision(this, collision)) {
        if (velocity.x > 0) {
          if (velocity.y == 0) {
            position.x = collision.position.x - hitbox.offsetX - hitbox.width;
          } else {
            handleDiagonalPosition(collision);
            break;
          }
        } else if (velocity.x < 0) {
          if (velocity.y == 0) {
            position.x = collision.position.x + collision.size.x;
          } else {
            handleDiagonalPosition(collision);
            break;
          }
        }
        velocity.x = 0;
        break;
      }
    }
  }
/// Determine which side of the player is colliding with the block
  CollisionSide _getCollisionSide(collision) {
    final playerX = position.x + hitbox.offsetX;
    final playerY = position.y + hitbox.offsetY;
    final playerWidth = hitbox.width;
    final playerHeight = hitbox.height;

    final blockX = collision.position.x;
    final blockY = collision.position.y;
    final blockWidth = collision.size.x;
    final blockHeight = collision.size.y;
    if (playerX + playerWidth > blockX && playerX < blockX) {
      return CollisionSide.left;
    } else if (playerX < blockX + blockWidth &&
        playerX + playerWidth > blockX + blockWidth) {
      return CollisionSide.right;
    } else if (playerY < blockY + blockHeight &&
        playerY + playerHeight > blockY + blockHeight) {
      return CollisionSide.bottom;
    } else if (playerY + playerHeight > blockY && playerY < blockY) {
      return CollisionSide.top;
    }

    return CollisionSide.none;
  }
/// Handle the position of the player when colliding diagonally
  void handleDiagonalPosition(collision) {
    final side = _getCollisionSide(collision);
    switch (side) {
      case CollisionSide.top:
        position.y = collision.position.y - hitbox.offsetY - hitbox.height;
        break;
      case CollisionSide.bottom:
        position.y = collision.position.y + collision.size.y;
        break;
      case CollisionSide.left:
        position.x = collision.position.x - hitbox.offsetX - hitbox.width;
        break;
      case CollisionSide.right:
        position.x = collision.position.x + collision.size.x;
        break;
      case CollisionSide.none:
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Weapon && !isBeingAttacked) {
      health -= other.damage;
      isBeingAttacked = true;
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Weapon) isBeingAttacked = false;
    super.onCollisionEnd(other);
  }
/// Flash the player when they are attacked
  void _personFlash(double dt) {
    opacity = 0.5;
    Future.delayed(const Duration(milliseconds: 100), () {
      opacity = 1;
    });
  }
  
}
