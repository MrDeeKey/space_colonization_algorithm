import 'package:flutter/material.dart';

class Leaf {
  final Offset pos;
  final double radius = 2;
  final Paint paint = Paint()..color = Colors.green;
  bool markedToDelete = false;

  Leaf({
    required this.pos,
  });

  void render(Canvas canvas) {
    canvas.drawCircle(pos, radius, paint);
  }
}
