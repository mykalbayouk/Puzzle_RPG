import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/maps/dungeons/dungeon_entrance.dart';
import 'package:puzzle_rpg/maps/level.dart';

class MainMap extends Level {
  MainChar player;

  MainMap({required this.player}) : super(levelName: 'MainMap', char: player);

  List<Entrance> dungeons = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    print(player.position);
  

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
  }
  
}