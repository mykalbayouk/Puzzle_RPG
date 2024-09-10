import 'package:flame/components.dart';
import 'package:puzzle_rpg/characters/main_char.dart';
import 'package:puzzle_rpg/tools/hearts.dart';


/// Manages the hearts of the player in the bar
class HeartManager extends PositionComponent {
  int maxHearts;
  final double padding;
  final List<Hearts> hearts = [];
  final MainChar player;

  HeartManager({
    required Vector2 position,
    required this.maxHearts,
    required this.padding,
    required this.player,
  }) {
    this.position = position;
  }

  late double maxHealth;
  late double healthPerHeart;

  @override
  Future<void> onLoad() async {
    size = Vector2(16 * maxHearts + padding * (maxHearts - 1), 16);

    maxHealth = player.health;
    healthPerHeart = maxHealth / maxHearts;

    double x = 0;
    double y = 0;

    // loads the hearts always to the top left of screen using the custom x and y value
    for (var i = 0; i < maxHearts; i++) {
      hearts.add(Hearts(
        position: Vector2(x, y),
      ));
      x += 16 + padding;
    }

    addAll(hearts);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateHearts();
    super.update(dt);
  }

  /// Update the hearts
  /// When the player takes damage, the hearts will update accordingly
  void _updateHearts() {
    double health = player.health;
    int fullHearts = (health / healthPerHeart).floor();
    double remainder = health % healthPerHeart;

    for (var i = 0; i < maxHearts; i++) {
      if (i < fullHearts) {
        hearts[i].sprite = hearts[i].fullHeart;
      } else if (i == fullHearts && remainder > 0) {
        if (remainder >= (3 * healthPerHeart / 4)) {
          hearts[i].sprite = hearts[i].tFHeart;
        } else if (remainder >= healthPerHeart / 2) {
          hearts[i].sprite = hearts[i].halfHeart;
        } else if (remainder >= healthPerHeart / 4) {
          hearts[i].sprite = hearts[i].oFHeart;
        } else {
          hearts[i].sprite = hearts[i].emptyHeart;
        }
      }
    }
  }

  /// Increase the max hearts of the player when they level up
  void increaseMaxHearts() {
    maxHearts++;
  }
}
