import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:puzzle_rpg/components/mechanic.dart';
import 'package:puzzle_rpg/maps/dungeons/dungeon.dart';

class DungeonOne extends Dungeon {
  

  DungeonOne({required super.char}) : super(levelName: 'dungeon_one');
  
  late Mechanic blueCY;
  late Mechanic redCy;
  late Mechanic yellowCy;
  late Mechanic button;

  List<Mechanic> mechs = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();



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
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _checkMechs();
  }

  void _checkMechs() {
    // todo
  }
}