class PipeSystem {

  final List<double> pipes = [300, 600];
  final double gap = 150;

  void update(double dt) {

    for (int i = 0; i < pipes.length; i++) {
      pipes[i] -= 100 * dt;
      if (pipes[i] < -50) {
        pipes[i] = 600; 
      }
    } 
  }
}