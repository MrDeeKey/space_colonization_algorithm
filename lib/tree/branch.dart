import 'package:flutter/material.dart';

class Branch {
  final Offset pos;
  final double radius = 2;
  final Offset dir;
  final Paint paint = Paint()..color = Colors.blueGrey;
  final Branch? parent;

  Branch({
    required this.pos,
    required this.parent,
    required this.dir,
  });

  void render(Canvas canvas) {
    if (parent != null) {
      canvas.drawLine(pos, parent!.pos, paint);
    }
  }
}
