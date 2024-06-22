import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/maps/dungeons/dungeon_one.dart';
import 'package:puzzle_rpg/maps/level.dart';

import 'package:puzzle_rpg/maps/main_map.dart';

class PuzRPG extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => Color.fromARGB(255, 33, 28, 54);
  MainChar player = MainChar();
  late JoystickComponent joystick;
  bool showJoystick = false;

  int index = 0;

  bool inital = true;


  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    _loadLevel();

    if (showJoystick) {
      addJoyStick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }

    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
      background:
          SpriteComponent(sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
      position: camera.viewfinder.position + Vector2(50, 50),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        // player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        // player.direction = PlayerDirection.right;
        break;
      case JoystickDirection.up:
        // player.direction = PlayerDirection.up;
        break;
      case JoystickDirection.down:
        // player.direction = PlayerDirection.down;
        break;
      case JoystickDirection.idle:
        player.isIdle = true;
        break;
    }
  }

  void _loadCamera(world) {
    // 250, 188
    camera = CameraComponent.withFixedResolution(
        world: world, width: 500, height: 500);
    camera.viewfinder.anchor = Anchor.center;
    camera.follow(player);
  }

  void loadNewLevel(int index) {    
    this.index = index;
    _loadLevel();
  }

  void _loadLevel() {    

    switch (index) {
      case 0:
        final mainMap = MainMap(player: player);
        add(mainMap);
        _loadCamera(mainMap);
        break;
      case 1:
        final dungeonOne = DungeonOne(char: player);
        add(dungeonOne);
        _loadCamera(dungeonOne);
        break;
      default:
        break;
    }

  }
}
