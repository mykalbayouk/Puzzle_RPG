import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_rpg/components/collision_block.dart';
import 'package:puzzle_rpg/components/player_hitbox.dart';
import 'package:puzzle_rpg/puz_rpg.dart';
import 'package:puzzle_rpg/utilities/util.dart';

enum PlayerState { idle, walk, attack }

enum Direction { up, down, left, right }

enum CollisionSide { top, bottom, left, right, none }

class Person extends SpriteAnimationComponent with HasGameRef<PuzRPG> {
  String type;
  String name;
  double speed;
  Person(
      {super.position,
      required this.type,
      required this.name,
      required this.speed});

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

  final double stepTime = .1;

  double horizontalMovement = 0;
  double verticalMovement = 0;
  late double moveSpeed;
  Vector2 velocity = Vector2.zero();
  late LogicalKeyboardKey priorityKey;

  List<CollisionBlock> collisions = [];

  PlayerHitbox hitbox =
      PlayerHitbox(offsetX: 1, offsetY: 1, width: 14, height: 14);

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();

    moveSpeed = speed;

    // add(RectangleHitbox(
    //   position: Vector2(hitbox.offsetX, hitbox.offsetY),
    //   size: Vector2(hitbox.width, hitbox.height),
    // ));

    priority = 1;

    debugMode = true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _updateAttack();
    _checkHorizontalCollisions();
    _checkVerticalCollisions();
    super.update(dt);
  }

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

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    velocity.y = verticalMovement * moveSpeed;
    if (velocity.y < 0) {
      animation = walkUp;
      direction = Direction.up;
    } else if (velocity.y > 0) {
      animation = walkDown;
      direction = Direction.down;
    } else if (velocity.x < 0) {
      animation = walkLeft;
      direction = Direction.left;
    } else if (velocity.x > 0) {
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

  void _updateAttack() {
    if (isAttacking) {
      switch (direction) {
        case Direction.up:
          animation = attackUp;
          break;
        case Direction.down:
          animation = attackDown;
          break;
        case Direction.left:
          animation = attackLeft;
          break;
        case Direction.right:
          animation = attackRight;
          break;
      }
      animation!.loop = false;
      isAttacking = false;
    }
  }

  void _checkVerticalCollisions() {
    for (final collision in collisions) {
      if (checkCollision(this, collision)) {
        if (velocity.y > 0) {
          if (velocity.x == 0) {
            position.y = collision.position.y - hitbox.offsetY - hitbox.height;
          } else {
            _handleDiagonalPosition(collision);
            break;
          }
        } else if (velocity.y < 0) {
          if (velocity.x == 0) {
            position.y = collision.position.y + collision.size.y;
          } else {
            _handleDiagonalPosition(collision);
            break;
          }
        }
        velocity.y = 0;
        break;
      }
    }
  }

  void _checkHorizontalCollisions() {
    for (final collision in collisions) {
      if (checkCollision(this, collision)) {
        if (velocity.x > 0) {
          if (velocity.y == 0) {
            position.x = collision.position.x - hitbox.offsetX - hitbox.width;
          } else {
            _handleDiagonalPosition(collision);
            break;
          }
        } else if (velocity.x < 0) {
          if (velocity.y == 0) {
            position.x = collision.position.x + collision.size.x;
          } else {
            _handleDiagonalPosition(collision);
            break;
          }
        }
        velocity.x = 0;
        break;
      }
    }
  }


  CollisionSide _getCollisionSide(CollisionBlock collision) {
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

  void _handleDiagonalPosition(CollisionBlock collision) {
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
}
