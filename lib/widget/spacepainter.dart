import 'dart:math';
import 'package:flutter/material.dart';

class Star {
  Offset position;
  double radius;
  Offset velocity;
  double opacity;

  Star({required this.position, required this.radius, required this.velocity, required this.opacity});

  void move(Size size) {
    position += velocity;

    // Bounce on edges
    if (position.dx < 0 || position.dx > size.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy < 0 || position.dy > size.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }

    // Twinkling effect
    opacity = 0.5 + 0.5 * sin(position.dx);
  }
}

class SpacePainter extends CustomPainter {
  final List<Star> stars;

  SpacePainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Draw space background
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw stars
    for (var star in stars) {
      paint.color = Colors.white.withOpacity(star.opacity);
      canvas.drawCircle(star.position, star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(SpacePainter oldDelegate) => true;
}
