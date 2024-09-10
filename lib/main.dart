import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_rpg/puz_rpg.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  // Create the game
  PuzRPG game = PuzRPG();
  runApp(GameWidget(game: kDebugMode ? PuzRPG() : game));
}
