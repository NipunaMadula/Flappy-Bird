import 'package:flappy_bird/game/game_state.dart';
import 'package:flutter/material.dart';
import "package:flame/game.dart";
import 'package:flame/input.dart';
import 'package:flappy_bird/game/bird.dart';
import 'package:flappy_bird/game/pipe_system.dart';

class FlappyBirdGame extends FlameGame with TapDetector {
  final Bird bird = Bird();
  final PipeSystem pipeSystem = PipeSystem();
  final GameManager gameManager = GameManager();
  
  @override
  Future<void> onLoad() async {
    reset();
  }
  
  void reset() {
    bird.y = size.y / 2;
    bird.velocity = 0;
    pipeSystem.reset();
    gameManager.reset();
  }
  
  @override
  void update(double dt) {
    if (gameManager.state == GameState.playing) {
      bird.update(dt);
      pipeSystem.update(dt);

    if (pipeSystem.checkScore(size.x / 3)) {
      gameManager.increaseScore();
      }
      
      if (checkCollisions()) {
        gameManager.state = GameState.gameOver;
      }
    }
    
    super.update(dt);
  }
  
  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF87CEEB),
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
    TextPainter scorePainter = TextPainter(
    text: TextSpan(
        text: 'Score: ${gameManager.score}',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    scorePainter.layout();
    scorePainter.paint(canvas, Offset(20, 20));

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: gameManager.state == GameState.ready ? 'Tap to Play' :
              gameManager.state == GameState.gameOver ? 'Game Over' : '',
        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.x/2 - textPainter.width/2, size.y/3));
    
    super.render(canvas);
  }
  
  @override
  void onTap() {
    if (gameManager.state == GameState.ready) {
      gameManager.state = GameState.playing;
    } else if (gameManager.state == GameState.playing) {
      bird.jump();
    } else if (gameManager.state == GameState.gameOver) {
      reset();
    }
  }
  
  bool checkCollisions() {
    // Ground and sky collision
    if (bird.y > size.y || bird.y < 0) {
      return true;
    }
    
    // Pipe collision
    for (double x in pipeSystem.pipes) {
      if ((x - size.x / 3).abs() < 25) {
        if (bird.y < size.y/2 - pipeSystem.gap/2 || 
            bird.y > size.y/2 + pipeSystem.gap/2) {
          return true;
        }
      }
    }
    
    return false;
  }
}