import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:space_colonization_algorithm/world.dart';

import 'game.dart';

main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  World world = World();
  final DateTime _initialTime = DateTime.now();
  double previous = 0.0;
  double pointerx = (ui.window.physicalSize / ui.window.devicePixelRatio).width / 2;
  double pointery = (ui.window.physicalSize / ui.window.devicePixelRatio).height / 2;
  double get currentTime => DateTime.now().difference(_initialTime).inMilliseconds / 1000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: pointerUpdate,
        onTapUp: pointerUpdate,
        onVerticalDragUpdate: pointerUpdate,
        onHorizontalDragUpdate: pointerUpdate,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext contex, Widget? child) {
            var curr = currentTime;
            var dt = curr - previous;
            previous = curr;

            return ClipRect(
              child: CustomPaint(
                size: MediaQuery.of(context).size,
                painter: MyGame(world, pointerx, pointery, dt),
                child: const Center(
                  child: null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    previous = currentTime;
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void pointerUpdate(details) {
    pointerx = details.globalPosition.dx;
    pointery = details.globalPosition.dy;
  }
}
