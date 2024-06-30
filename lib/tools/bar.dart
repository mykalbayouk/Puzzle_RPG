import 'package:flame/components.dart';
import 'package:puzzle_rpg/characters/person.dart';
import 'package:puzzle_rpg/puz_rpg.dart';

class Bar extends SpriteComponent with HasGameRef<PuzRPG>{
  final String type;
  final Person char;
  String name;

  Bar({
    required Vector2 position,
    required this.type,
    required this.char,
    required this.name,
  }) {
    this.position = position;
  }

  late double totalValue;

  double percent = 100;

  @override
  Future<void> onLoad() async {
    _loadBar();

    totalValue = type == 'Health' ? char.health : char.exp;

    if (type == 'Exp') {
      size = Vector2(100, 16);
    }
    return super.onLoad();
  }

  void _loadBar() {
    sprite = type == 'Exp' ? 
      Sprite(gameRef.images.fromCache('Ui/$type/10$name.png')) :
    Sprite(gameRef.images.fromCache('Ui/$type/100$name.png'));
  }

  @override
  void update(double dt) {
    _updateBar();
    super.update(dt);
  }

  void _updateBar() {
    double changeValue = percent;
    
    if (type == 'Health') { 
      changeValue = char.health / totalValue * 100;
    } else if (type == 'Exp') {
      changeValue = char.exp / totalValue * 100;
    }


    if (changeValue == 100) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/100$name.png'));
    } else if (changeValue >= 90) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/90$name.png'));
    } else if (changeValue >= 80) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/80$name.png'));
    } else if (changeValue >= 70) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/70$name.png'));
    } else if (changeValue >= 60) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/60$name.png'));
    } else if (changeValue >= 50) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/50$name.png'));
    } else if (changeValue >= 40) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/40$name.png'));
    } else if (changeValue >= 30) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/30$name.png'));
    } else if (changeValue >= 20) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/20$name.png'));
    } else if (changeValue >= 10) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/10$name.png'));
    } else if (changeValue >= 0) {
      sprite = Sprite(gameRef.images.fromCache('Ui/$type/0$name.png'));
    }
  }



}