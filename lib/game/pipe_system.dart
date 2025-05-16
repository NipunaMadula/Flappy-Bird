class PipeSystem {

  final List<double> pipes = [300, 600];
  final double gap = 150;

  List<bool> pipePassed = [false, false];

  void update(double dt) {

    for (int i = 0; i < pipes.length; i++) {
      pipes[i] -= 100 * dt;
      if (pipes[i] < -50) {
        pipes[i] = 600; 
        pipePassed[i] = false;
      }
    } 
  }

  bool checkScore(double birdX) {
    for (int i = 0; i < pipes.length; i++) {
      if (!pipePassed[i] && pipes[i] < birdX) {
        pipePassed[i] = true;
        return true;
      }
    }
    return false;
  }
  
  void reset() {
    pipes[0] = 300;
    pipes[1] = 600;
    pipePassed = [false, false];
  }
}