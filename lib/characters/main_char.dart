import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_rpg/characters/person.dart';
import 'package:puzzle_rpg/components/mechanic.dart';
import 'package:puzzle_rpg/maps/dungeons/dungeon_entrance.dart';
import 'package:puzzle_rpg/utilities/util.dart';

class MainChar extends Person with KeyboardHandler {
  MainChar() : super(type: 'Characters', name: 'Boy', speed: 300);

  List<Entrance> dungeons = [];
  List<Entrance> exits = [];
  List<Mechanic> mechanics = [];

  double ticker = 0;

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

    if (isKeyDown) {
      isIdle = false;
      horizontalMovement += isRight ? 1 : 0;
      horizontalMovement -= isLeft ? 1 : 0;
      verticalMovement += isDown ? 1 : 0;
      verticalMovement -= isUp ? 1 : 0;

      if (isSpace && !isKeyRepeat) {
        isAttacking = true; // Mark that an attack is happening
      } else if (isSpace && isKeyRepeat) {
        isIdle = true;
      }

      if (isE) {
        animation = interact;
        _checkIfMech();
      }
    } else {
      isIdle = true;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _checkIfDungeon();
    _checkIfExit();
  }

  void _checkIfDungeon() {
    for (final dungeon in dungeons) {
      if (checkCollision(this, dungeon)) {
        game.loadNewLevel(1);
        break;
      }
    }
  }

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

  void _checkIfMech() {
    for (final mech in mechanics) {
      if (isNear(this, mech)) {
        mech.trigger();
        print('Mechanic triggered');
        break;
      }
    }
  }
}
