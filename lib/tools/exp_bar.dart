import 'package:flame/components.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/puz_rpg.dart';

class ExpBar extends SpriteComponent with HasGameRef<PuzRPG>{
  final MainChar player;
  
  ExpBar({
    required Vector2 position,
    required this.player,
  }) {
    this.position = position;
  }

  late double totalValue;

  @override
  Future<void> onLoad() async {
    _loadBar();
    return super.onLoad();
  }

  void _loadBar() {
    sprite = Sprite(game.images.fromCache('Ui/Exp/0XP.png'));
  }

  @override
  void update(double dt) {
    _updateBar();
    super.update(dt);
  }

  void _updateBar() {
    totalValue = player.expToNextLevel;

    // tokenValue is the value of each token in the xp bar since there are 8 tokens
    int tokenValue = totalValue ~/ 8;

    for (var i = 0; i <= 8; i++) {
      if (player.exp >= tokenValue * i) {
        sprite = Sprite(game.images.fromCache('Ui/Exp/${i}XP.png'));
      }
    }
  }

  
}