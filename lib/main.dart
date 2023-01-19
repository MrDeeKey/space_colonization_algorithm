import 'dart:math' as math;
import 'package:flutter/material.dart';

main() {
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
  World world = World(0.0, 0.0);
  final DateTime _initialTime = DateTime.now();
  double previous = 0.0;
  double pointerx = 0;
  double pointery = 0;
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

            return CustomPaint(
              size: MediaQuery.of(context).size,
              painter: MyGame(world, pointerx, pointery, dt),
              child: const Center(
                child: Text('This is your UI'),
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

class MyGame extends CustomPainter {
  final World world;
  final double x;
  final double y;
  final double t;

  MyGame(this.world, this.x, this.y, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    world.input(x, y);
    world.update(t);
    world.render(t, canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class World {
  var _turn = 0.0;
  double _x;
  double _y;

  World(this._x, this._y);

  void input(double x, double y) {
    _x = x;
    _y = y;
  }

  void render(double t, Canvas canvas) {
    var tau = math.pi * 2;

    canvas.drawPaint(Paint()..color = const Color.fromARGB(255, 47, 44, 50));
    canvas.save();
    canvas.translate(_x, _y);
    canvas.rotate(tau * _turn);
    var white = Paint()..color = const Color(0xffffffff);
    var size = 200.0;
    canvas.drawRect(Rect.fromLTWH(-size / 2, -size / 2, size, size), white);
    canvas.restore();
  }

  void update(double t) {
    var rotationsPerSecond = 0.25;
    _turn += t * rotationsPerSecond;
  }
}
