import 'package:flutter/material.dart';

class HealthBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint = Paint()..shader = LinearGradient(
    //   colors: [Colors.white, Colors.greenAccent, Colors.teal],
    //   begin: Alignment.topLeft,
    //   end: Alignment.bottomRight,
    // ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
    //   ..style = PaintingStyle.fill;

    // Draw a cross symbol (representing healthcare)
    Paint crossPaint = Paint()..color = Colors.red;
    double crossSize = 40;
    double crossX = size.width * 0.8;
    double crossY = size.height * 0.2;

    // Vertical part of the cross
    canvas.drawRect(
        Rect.fromLTWH(crossX - 10, crossY - crossSize / 2, 20, crossSize),
        crossPaint);
    // Horizontal part of the cross
    canvas.drawRect(
        Rect.fromLTWH(crossX - crossSize / 2, crossY - 10, crossSize, 20),
        crossPaint);

    // Draw an ECG heartbeat line
    Paint linePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Path ecgPath = Path();
    double startX = size.width * 0.1;
    double startY = size.height * 0.6;
    ecgPath.moveTo(startX, startY);

    ecgPath.lineTo(startX + 30, startY - 20);
    ecgPath.lineTo(startX + 60, startY);
    ecgPath.lineTo(startX + 90, startY - 30);
    ecgPath.lineTo(startX + 120, startY + 40);
    ecgPath.lineTo(startX + 150, startY - 20);
    ecgPath.lineTo(startX + 180, startY);

    canvas.drawPath(ecgPath, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}