import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:puzzle_rpg/components/mechanic.dart';
import 'package:puzzle_rpg/maps/dungeons/dungeon_entrance.dart';
import 'package:puzzle_rpg/maps/level.dart';

/// The first dungeon of the game
class DungeonOne extends Level {
  

  DungeonOne({required super.char}) : super(levelName: 'dungeon_one');
  
  late Mechanic blueCY;
  late Mechanic redCy;
  late Mechanic yellowCy;
  late Mechanic button;

  List<Mechanic> mechs = [];

  

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Loads the mechanics of the dungeon
    final mechsLayer = level.tileMap.getLayer<ObjectGroup>('Mechs');
    for(final mech in mechsLayer!.objects) {
      switch(mech.class_) {
        case 'blue_cy':
          blueCY = Mechanic(
            position: Vector2(mech.x, mech.y),
            size: Vector2(mech.width, mech.height),
          );
          collisions.add(blueCY);
          mechs.add(blueCY);
          break;
        case 'red_cy':
          redCy = Mechanic(
            position: Vector2(mech.x, mech.y),
            size: Vector2(mech.width, mech.height),
          );
          collisions.add(redCy);
          mechs.add(redCy);
          break;
        case 'yellow_cy':
          yellowCy = Mechanic(
            position: Vector2(mech.x, mech.y),
            size: Vector2(mech.width, mech.height),
          );
          collisions.add(yellowCy);
          mechs.add(yellowCy);
          break;
        case 'main_button':
          button = Mechanic(
            position: Vector2(mech.x, mech.y),
            size: Vector2(mech.width, mech.height),
          );
          collisions.add(button);
          mechs.add(button);
          break;
        default:
          break;
      }
    }
    char.mechanics = mechs;

    final exitLayer = level.tileMap.getLayer<ObjectGroup>('Exit');
    for(final exit in exitLayer!.objects) {
      switch(exit.class_) {
        case 'exit':
          final exitBlock = Entrance(
            position: Vector2(exit.x, exit.y),
            size: Vector2(exit.width, exit.height));          
          add(exitBlock);
          char.exits.add(exitBlock);
          break;
        default:
          break;
      }
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _checkMechs();
  }

  /// Check the mechanics of the dungeon, when completed, player gets reward TODO: Implement the reward
  void _checkMechs() {
    // Todo: Implement the logic for the mechanics
  }
}