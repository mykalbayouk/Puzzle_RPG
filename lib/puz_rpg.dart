import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/maps/dungeons/dungeon_one.dart';

import 'package:puzzle_rpg/maps/main_map.dart';

class PuzRPG extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override

  // Sets the background color of the game to white
  Color backgroundColor() => const Color.fromARGB(255, 255, 255, 255);
  MainChar player = MainChar();
  late JoystickComponent joystick;
  bool showJoystick = false;

  // Camera window size
  double cameraWidth = 250;
  double cameraHeight = 188;

  // what level the player is on
  int index = 0;

  // which spawn point the player is at
  int playerSpawn = 0;
  bool gameOver = false;

  /// Called when the game is initialized
  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    // Load the first level
    _loadLevel();

    // Add the joystick
    if (showJoystick) {
      addJoyStick();
    }

    debugMode = false;
    return super.onLoad();
  }

  /// Called repeatedly in the game loop
  @override
  void update(double dt) {

    // Update the joystick
    if (showJoystick) {
      updateJoystick();
    }

    // Check if the player is dead
    _gameOver();
    super.update(dt);
  }

  /// Add Joystick to the game screen
  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
      background:
          SpriteComponent(sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
      position: camera.viewfinder.position + Vector2(50, 50),
    );
    add(joystick);
  }

  /// Update the player's movement based on the joystick
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement--;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement++;
        break;
      case JoystickDirection.up:
        player.verticalMovement--;
        break;
      case JoystickDirection.down:
        player.verticalMovement++;
        break;
      case JoystickDirection.idle:
        player.horizontalMovement = 0;
        player.verticalMovement = 0;
        player.isIdle = true;
        break;
    }
  }

  /// Load the camera component
  void _loadCamera(world) {
  // Create a camera component with a fixed resolution
    camera = CameraComponent.withFixedResolution(
        world: world, width: cameraWidth, height: cameraHeight);
    camera.viewfinder.anchor = Anchor.center;
    camera.follow(player);
  }

  /// Updates the index variable and loads new level
  /// based on the index
  /// 0 = MainMap
  /// 1 = DungeonOne
  /// 2 = DungeonTwo
  /// 3 = DungeonThree
  /// 4 = DungeonFour
  void loadNewLevel(int index) {    
    this.index = index;
    _loadLevel();
  }



  /// Load the level based on the index
  /// Creates a map object based on the index
  /// Loads in camera component
  void _loadLevel() {    
    MainMap mainMap;
    DungeonOne dungeonOne;

    switch (index) {
      case 0:
        mainMap = MainMap(player: player, playerSpawn: playerSpawn);
        add(mainMap);
        _loadCamera(mainMap);
        break;
      case 1:
        dungeonOne = DungeonOne(char: player);
        add(dungeonOne);
        _loadCamera(dungeonOne);
        break;
      default:
        break;
    }

  }

  /// Check if the player is dead
  /// If the player is dead, reset the game
  /// and load the first level
  void _gameOver() {
    if (gameOver) {
      removeAll(children);
      playerSpawn = 0;
      player = MainChar();
      loadNewLevel(0);

      gameOver = false;
    }
  }
}
