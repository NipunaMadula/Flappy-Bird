import "package:flame/game.dart";
import 'package:flame/input.dart';

class FlappyBirdGame extends FlameGame with TapDetector {
  @override
  Future<void> onLoad() async {

  }
  
  @override
  void onTap() {
    print('Screen tapped!');
  }
}