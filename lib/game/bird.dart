class Bird {
  double y = 0;
  double velocity = 0;
  final double gravity = 800;

  void update(double dt) {
    velocity += gravity * dt;
    y += velocity * dt;
  }

  void jump() {
   velocity = -300;
  }
}