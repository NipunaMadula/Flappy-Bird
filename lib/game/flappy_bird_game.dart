import 'package:flutter/material.dart';
import "package:flame/game.dart";
import 'package:flame/input.dart';

class FlappyBirdGame extends FlameGame with TapDetector {
  @override
  Future<void> onLoad() async {

  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF87CEEB), // Sky blue
    );
    super.render(canvas);
  }
  
  @override
  void onTap() {
    print('Screen tapped!');
  }
}