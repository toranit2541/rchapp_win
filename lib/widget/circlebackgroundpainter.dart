import 'package:flutter/material.dart';

class CircleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..
    shader = LinearGradient(
    colors: [Colors.greenAccent, Colors.teal, Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
    ..style = PaintingStyle.fill;

    // Draw multiple circles at different positions
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 100, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 80, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 120, paint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.9), 90, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.8), 110, paint);

    Paint solidPaint = Paint()..color = Colors.lightGreenAccent;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), 50, solidPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}