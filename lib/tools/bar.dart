import 'package:flame/components.dart';
import 'package:puzzle_rpg/characters/person.dart';
import 'package:puzzle_rpg/puz_rpg.dart';

  /// A health bar for the enemy
  class Bar extends SpriteComponent with HasGameRef<PuzRPG>{

  final Person char;
  Bar({
    required Vector2 position,
    required this.char,
  }) {
    this.position = position;
  }

  // The total value of the health bar
  late double totalValue;

  // The percentage of the health bar
  double percent = 100;

  @override
  Future<void> onLoad() async {
    _loadBar();
    totalValue = char.health;
    return super.onLoad();
  }

  /// Load the health bar from the cache
  void _loadBar() {
    sprite = Sprite(gameRef.images.fromCache('Ui/Health/100enemy.png'));
  }

  @override
  void update(double dt) {
    _updateBar();
    super.update(dt);
  }

  /// Update the health bar
  /// Check the health of the character and update the health bar accordingly
  void _updateBar() {
    double changeValue = char.health / totalValue * 100;
    for (var i = 100; i >= 0; i-=10) {
      if (i > changeValue) {
        sprite = Sprite(gameRef.images.fromCache('Ui/Health/${i}enemy.png'));
      }
    }

  }



}