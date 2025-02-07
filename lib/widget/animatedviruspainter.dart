import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedVirusPainter extends CustomPainter {
  final List<VirusObject> viruses;
  AnimatedVirusPainter(this.viruses);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()..color = Colors.black87;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    for (var virus in viruses) {
      _drawVirusParticle(canvas, virus);
    }
  }

  void _drawVirusParticle(Canvas canvas, VirusObject virus) {
    Paint virusPaint = Paint()
      ..color = virus.color.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(virus.position, virus.radius, virusPaint);

    // Draw spikes
    Paint spikePaint = Paint()
      ..color = virus.color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (double angle = 0; angle < 2 * pi; angle += pi / 6) {
      double spikeX = virus.position.dx + (virus.radius + 8) * cos(angle);
      double spikeY = virus.position.dy + (virus.radius + 8) * sin(angle);
      canvas.drawLine(virus.position, Offset(spikeX, spikeY), spikePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class VirusObject {
  Offset position;
  double radius;
  Color color;
  Offset velocity;

  VirusObject({
    required this.position,
    required this.radius,
    required this.color,
    required this.velocity,
  });

  void move(Size size) {
    position += velocity;

    // Bounce off walls
    if (position.dx <= 0 || position.dx >= size.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy <= 0 || position.dy >= size.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }
}