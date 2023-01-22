import 'package:flutter/material.dart';
import 'package:space_colonization_algorithm/world.dart';

class MyGame extends CustomPainter {
  final World world;
  final double x;
  final double y;
  final double dt;

  MyGame(this.world, this.x, this.y, this.dt);

  @override
  void paint(Canvas canvas, Size size) {
    world.update(dt);
    world.render(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
