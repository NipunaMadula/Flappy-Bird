import 'package:flappy_bird/game/game_state.dart';
import 'package:flutter/material.dart';
import "package:flame/game.dart";
import 'package:flame/input.dart';
import 'package:flappy_bird/game/bird.dart';
import 'package:flappy_bird/game/pipe_system.dart';
import 'package:flame/sprite.dart';

class FlappyBirdGame extends FlameGame with TapDetector {
  final Bird bird = Bird();
  final PipeSystem pipeSystem = PipeSystem();
  final GameManager gameManager = GameManager();

  late Sprite birdSprite;
  late Sprite pipeSprite;
  late Sprite backgroundSprite;
  
  @override
  Future<void> onLoad() async {

    birdSprite = await Sprite.load('bird.png');
    pipeSprite = await Sprite.load('pipe.png');
    backgroundSprite = await Sprite.load('background.jpg');
    
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
    backgroundSprite.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(size.x, size.y),
    );
    
    for (double x in pipeSystem.pipes) {
      canvas.save();
      canvas.scale(1, -1);
      pipeSprite.render(
        canvas,
        position: Vector2(x, -size.y/2 + pipeSystem.gap/2),
        size: Vector2(50, size.y/2 - pipeSystem.gap/2),
      );
      canvas.restore();
      
      pipeSprite.render(
        canvas,
        position: Vector2(x, size.y/2 + pipeSystem.gap/2),
        size: Vector2(50, size.y/2 - pipeSystem.gap/2),
      );
    }
    
    canvas.save();
    final birdPosition = Vector2(size.x / 3, bird.y);
    canvas.translate(birdPosition.x, birdPosition.y);
    
    final rotation = (bird.velocity.clamp(-300, 300) / 300) * 0.5;
    canvas.rotate(rotation);
    
    birdSprite.render(
      canvas,
      position: Vector2(-20, -20), 
      size: Vector2(45, 40),
    );
    
    canvas.restore();
    
    TextPainter scorePainter = TextPainter(
      text: TextSpan(
        text: 'Score: ${gameManager.score}',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    scorePainter.layout();
    scorePainter.paint(canvas, Offset(20, 20));
    
    if (gameManager.state == GameState.ready || gameManager.state == GameState.gameOver) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = Colors.black.withOpacity(0.3),
      );
      
      String mainText = gameManager.state == GameState.ready ? 'Tap to Play' : 'Game Over';
      TextPainter mainTextPainter = TextPainter(
        text: TextSpan(
          text: mainText,
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      mainTextPainter.layout();
      mainTextPainter.paint(canvas, Offset(size.x/2 - mainTextPainter.width/2, size.y/3));
      
      if (gameManager.state == GameState.gameOver) {
        TextPainter scorePainter = TextPainter(
          text: TextSpan(
            text: 'Final Score: ${gameManager.score}',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          textDirection: TextDirection.ltr,
        );
        scorePainter.layout();
        scorePainter.paint(canvas, Offset(size.x/2 - scorePainter.width/2, size.y/2));
        
        TextPainter tapTextPainter = TextPainter(
          text: const TextSpan(
            text: 'Tap to restart',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          textDirection: TextDirection.ltr,
        );
        tapTextPainter.layout();
        tapTextPainter.paint(canvas, Offset(size.x/2 - tapTextPainter.width/2, size.y/2 + 40));
      }
    }
    
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