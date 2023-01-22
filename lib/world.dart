import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'tree/branch.dart';
import 'tree/tree.dart';

class World {
  // ignore: unused_field
  double? _cursorX;
  // ignore: unused_field
  double? _cursorY;
  Tree tree = Tree(crownBounds: Rect.fromLTWH(0, 0, size.width, size.height * 0.75), rootBranches: [
    Branch(
      pos: Offset(size.width / 2, size.height),
      parent: null,
      dir: const Offset(1, -1),
    ),
  ]);

  void input(double x, double y) {
    _cursorX = x;
    _cursorY = y;
  }

  void update(double dt) {
    tree.grow(dt);
  }

  void render(Canvas canvas) {
    canvas.drawColor(const Color.fromARGB(255, 20, 20, 29), BlendMode.clear);
    tree.render(canvas);
  }

  static Size get size => Size((ui.window.physicalSize / ui.window.devicePixelRatio).width,
      (ui.window.physicalSize / ui.window.devicePixelRatio).height);
}
