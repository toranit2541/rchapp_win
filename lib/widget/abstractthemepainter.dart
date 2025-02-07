import 'package:flutter/material.dart';

class AbstractThemePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.greenAccent, Colors.teal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Draw background gradient
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw abstract shapes
    final shapePaint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.3), 80, shapePaint);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.6, size.height * 0.5, 100, 150), shapePaint);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.2, size.height * 0.8)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.6, size.width * 0.8, size.height * 0.9)
        ..close(),
      shapePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}