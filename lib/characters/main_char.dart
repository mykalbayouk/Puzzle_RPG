import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_rpg/characters/enemy.dart';
import 'package:puzzle_rpg/characters/person.dart';
import 'package:puzzle_rpg/tools/heart_manager.dart';
import 'package:puzzle_rpg/components/mechanic.dart';
import 'package:puzzle_rpg/maps/dungeons/dungeon_entrance.dart';
import 'package:puzzle_rpg/tools/exp_bar.dart';
import 'package:puzzle_rpg/utilities/util.dart';

/// The main character of the game
class MainChar extends Person with KeyboardHandler {
  // character can be changed later TODO
  MainChar() : super(type: 'Characters', name: 'Boy', speed: 300, health: 100);

  List<Entrance> dungeons = [];
  List<Entrance> exits = [];
  List<Mechanic> mechanics = [];
  List<Enemy> enemies = [];

  // constants for main player, may be changed closer to release
  double ticker = 0;

  double exp = 0;

  int level = 1;

  double expToNextLevel = 100;

  late HeartManager healthBar;

  late double xBar;
  late double yBar;

  

  @override
  Future<void> onLoad() async {
    xBar = -game.cameraWidth / 2 + 5;
    yBar = -game.cameraHeight / 2 + 5;
    _loadBars();

    return super.onLoad();
  }
  
  /// Handle keyboard events
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;

    final isKeyDown = keysPressed.isNotEmpty;
    final isKeyRepeat = event is KeyRepeatEvent;

    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);
    final isUp = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    final isDown = keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);
    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    final isE = keysPressed.contains(LogicalKeyboardKey.keyE);

    final isQ = keysPressed.contains(LogicalKeyboardKey.keyQ);

    if (isKeyDown) {
      if (animation != attackDown &&
          animation != attackUp &&
          animation != attackLeft &&
          animation != attackRight &&
          animation != interact) {
        isIdle = false;
        horizontalMovement += isRight ? 1 : 0;
        horizontalMovement -= isLeft ? 1 : 0;
        verticalMovement += isDown ? 1 : 0;
        verticalMovement -= isUp ? 1 : 0;
      }

      if (isSpace && !isKeyRepeat) {
        isAttacking = true;
      } else if (isSpace && isKeyRepeat) {
        isIdle = true;
      }
      // interact with objects
      if (isE) {
        animation = interact;
        _checkIfMech();
      }

      // TODO debug for exp testing
      if (isQ){
        exp += 25;
      }

    } else {
      isIdle = true;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    /// TODO need to optimize so not checking all of these every frame
    super.update(dt);
    _checkIfDungeon();
    _checkIfExit();
    checkHorizontalCollisions(enemies);
    checkVerticalCollisions(enemies);
    _checkHealth();
    _checkLevel();
  }


  /// Check if player has collided with dungeon
  void _checkIfDungeon() {
    for (final dungeon in dungeons) {
      if (checkCollision(this, dungeon)) {
        game.loadNewLevel(1);
        break;
      }
    }
  }


  /// Check if player has collided with exit
  void _checkIfExit() {
    for (final exit in exits) {
      if (checkCollision(this, exit)) {
        switch (game.index) {
          case 1:
            game.playerSpawn = 1;
            game.loadNewLevel(0);
            break;
          default:
            break;
        }
        break;
      }
    }
  }

  /// Check if player is near mechanic
  void _checkIfMech() {
    for (final mech in mechanics) {
      if (isNear(this, mech)) {
        mech.trigger();
        print('Mechanic triggered');
        break;
      }
    }
  }
  
  /// Check if player is dead
  void _checkHealth() {
    if (health <= 0) {
      game.gameOver = true;
    }
  }
  
  /// Load the health and exp bars
  void _loadBars() {

    healthBar = HeartManager(position: Vector2(xBar, yBar), maxHearts: level + 3, padding: .5, player: this);
    add(healthBar);

    final expBar = ExpBar(position: Vector2(xBar + 1, yBar + 16), player: this);
    add(expBar);
  }
  

  /// Check if player has leveled up
  void _checkLevel() {
    if (exp >= expToNextLevel) {
      if (level != 5) { 
        // max level is 5
        level++;
        exp = 0;
        expToNextLevel += 50;
        weaponDamage += 10;
        health = 100;
        health += level * 25;
        remove(healthBar);

        healthBar = HeartManager(position: Vector2(xBar, yBar), maxHearts: level + 3, padding: .5, player: this);
        add(healthBar);        
      }
    }
  }
  

}
