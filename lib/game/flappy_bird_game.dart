import 'package:flutter/material.dart';
import "package:flame/game.dart";
import 'package:flame/input.dart';
import 'package:flappy_bird/game/bird.dart';


class FlappyBirdGame extends FlameGame with TapDetector {

  final Bird bird = Bird();

  @override
  Future<void> onLoad() async {
    bird.y = size.y / 2;
  }

  @override
  void update(double dt) {
    bird.update(dt);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF87CEEB), // Sky blue
    );

    canvas.drawCircle(
      Offset(size.x / 3, bird.y),
      20,
      Paint()..color = Colors.red,
    );

    super.render(canvas);
  }
  
  @override
  void onTap() {
    bird.jump();
  }
}