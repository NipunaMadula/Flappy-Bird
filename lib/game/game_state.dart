enum GameState {
  ready,
  playing,
  gameOver,
}

class GameManager {
  GameState state = GameState.ready;
  int score = 0;

  void reset() {
    state = GameState.ready;
    score = 0;
  }
}