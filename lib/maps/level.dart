import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:puzzle_rpg/characters/enemy.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/components/collision_block.dart';

class Level extends World {
  String levelName;
  final MainChar char;
  Level({required this.levelName, required this.char});

  late TiledComponent level;
  List<CollisionBlock> collisions = [];
  List<Enemy> enemies = [];


  bool _isLoaded = false;

  @override
  Future<void> onLoad() async {
    if (_isLoaded) {
      return;
    }
    _isLoaded = true;

    

    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    
    debugMode = true;

    add(level);

    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (final spawn in spawnPointLayer!.objects) {
      switch (spawn.class_) {
        case 'Player':
          char.position = Vector2(spawn.x, spawn.y);
          add(char);
          break;
        case 'enemy':
          double oNX = spawn.properties.getValue('offNegX');
          double oNY = spawn.properties.getValue('offNegY');
          double oPX = spawn.properties.getValue('offPosX');
          double oPY = spawn.properties.getValue('offPosY');
          final enemy = Enemy(
            myPos: Vector2(spawn.x, spawn.y),
            offNegX: oNX,
            offNegY: oNY,
            offPosX: oPX,
            offPosY: oPY,
          );
          enemies.add(enemy);
          add(enemy);
          break;
        default:
          break;
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    for (final collision in collisionsLayer!.objects) {
      switch (collision.class_) {
        case 'coll':
          final coll = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          collisions.add(coll);
          add(coll);
          break;
        default:
          break;
      }
    }
    char.collisions = collisions;
    return super.onLoad();
  }
}
