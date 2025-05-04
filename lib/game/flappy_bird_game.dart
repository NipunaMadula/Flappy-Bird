import 'package:flutter/material.dart';
import "package:flame/game.dart";
import 'package:flame/input.dart';
import 'package:flappy_bird/game/bird.dart';
import 'package:flappy_bird/game/pipe_system.dart';


class FlappyBirdGame extends FlameGame with TapDetector {

  final Bird bird = Bird();
  final PipeSystem pipeSystem = PipeSystem();

  @override
  Future<void> onLoad() async {
    bird.y = size.y / 2;
  }

  @override
  void update(double dt) {
    bird.update(dt);
    pipeSystem.update(dt);
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

    final Paint pipePaint = Paint()..color = Colors.green;
    for (double x in pipeSystem.pipes) {
      canvas.drawRect(
        Rect.fromLTWH(x, 0, 50, size.y/2 - pipeSystem.gap/2),
        pipePaint,
      );

      canvas.drawRect(
        Rect.fromLTWH(x, size.y/2 + pipeSystem.gap/2, 50, size.y/2 - pipeSystem.gap/2),
        pipePaint,
      );
    }

    super.render(canvas);
  }
  
  @override
  void onTap() {
    bird.jump();
  }
}