import 'package:flutter/material.dart';
import 'dart:math';

class VirusBackgroundPainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    Paint backgroundPaint = Paint()..color = Colors.black87;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw virus-like particles
    for (int i = 0; i < 10; i++) {
      _drawVirusParticle(canvas, size);
    }
  }

  void _drawVirusParticle(Canvas canvas, Size size) {
    double x = _random.nextDouble() * size.width;
    double y = _random.nextDouble() * size.height;
    double radius = _random.nextDouble() * 40 + 20; // Virus size

    Paint virusPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), radius, virusPaint);

    // Draw spikes around the virus
    Paint spikePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (double angle = 0; angle < 2 * pi; angle += pi / 6) {
      double spikeX = x + (radius + 10) * cos(angle);
      double spikeY = y + (radius + 10) * sin(angle);
      canvas.drawLine(Offset(x, y), Offset(spikeX, spikeY), spikePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}