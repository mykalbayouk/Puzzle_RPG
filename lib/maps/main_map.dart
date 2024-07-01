import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/maps/dungeons/dungeon_entrance.dart';
import 'package:puzzle_rpg/maps/level.dart';

class MainMap extends Level {
  MainChar player;
  int playerSpawn;

  MainMap({required this.player, required this.playerSpawn}) : super(levelName: 'MainMap', char: player);

  List<Entrance> dungeons = [];

  // TR(Top Right) - 0 (Index), BR(Bottom Right) - 1, BL(Bottom Left) - 2, TL(Top Left) - 3
  List<Vector2> playerSpawns = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    final dungeonLayer = level.tileMap.getLayer<ObjectGroup>('Dungeons');
    for(final dung in dungeonLayer!.objects) {
      switch(dung.class_) {
        case 'dungeon':
          final dungeon = Entrance(
            position: Vector2(dung.x, dung.y),
            size: Vector2(dung.width, dung.height),
          );
          add(dungeon);
          dungeons.add(dungeon);
          break;
        default:
          break;
      }
    }
    char.dungeons = dungeons;


    final exitsLayer = level.tileMap.getLayer<ObjectGroup>('Exits');
    for(final exit in exitsLayer!.objects) {
      switch(exit.class_) {
        case 'Exit_TR':
          playerSpawns.add(Vector2(exit.x, exit.y));
          break;
        default:
          break;
      }
    }

    _choosePlayerSpawn(); 

  }

  void _choosePlayerSpawn() {
    switch(playerSpawn) {
      case 1:
        player.position = playerSpawns[0];
        break;
      case 2:
        player.position = playerSpawns[1];
        break;
      case 3:
        player.position = playerSpawns[2];
        break;
    }
  }
  
}