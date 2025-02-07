

import 'package:flutter/material.dart';

class TriangleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..shader = LinearGradient(
      colors: [Colors.white, Colors.greenAccent, Colors.teal],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Triangle 1
    Path triangle1 = Path();
    triangle1.moveTo(size.width * 0.2, size.height * 0.1);
    triangle1.lineTo(size.width * 0.4, size.height * 0.3);
    triangle1.lineTo(size.width * 0.1, size.height * 0.4);
    triangle1.close();
    canvas.drawPath(triangle1, paint);

    // Triangle 2
    Path triangle2 = Path();
    triangle2.moveTo(size.width * 0.8, size.height * 0.2);
    triangle2.lineTo(size.width * 0.6, size.height * 0.5);
    triangle2.lineTo(size.width * 0.9, size.height * 0.6);
    triangle2.close();
    canvas.drawPath(triangle2, paint);

    // Triangle 3
    Path triangle3 = Path();
    triangle3.moveTo(size.width * 0.5, size.height * 0.7);
    triangle3.lineTo(size.width * 0.7, size.height * 0.9);
    triangle3.lineTo(size.width * 0.3, size.height);
    triangle3.close();
    canvas.drawPath(triangle3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}