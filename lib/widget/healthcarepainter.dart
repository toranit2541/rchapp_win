import 'package:flutter/material.dart';

class HealthCarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.greenAccent, Colors.teal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw heartbeat line
    final heartbeatPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width * 0.35, size.height * 0.6);
    path.lineTo(size.width * 0.7, size.height * 0.6);

    canvas.drawPath(path, heartbeatPaint);

    // Draw medical cross
    final crossPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final double crossSize = 80.0;
    final Offset center = Offset(size.width /2, size.height/2);

    canvas.drawRect(
        Rect.fromCenter(center: center, width: crossSize, height: crossSize / 3),
        crossPaint);
    canvas.drawRect(
        Rect.fromCenter(center: center, width: crossSize / 3, height: crossSize),
        crossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}