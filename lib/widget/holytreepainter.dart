// ===============================
// 🎨 Custom Painter for Holy Tree
// ===============================
import 'package:flutter/material.dart';

class HolyTreePainter extends CustomPainter {
  final List<LightOrb> lightOrbs;

  HolyTreePainter(this.lightOrbs);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint treePaint = Paint()..color = Colors.brown;
    final Paint leavesPaint = Paint()
      ..color = Colors.green
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15); // Glowing effect

    // Draw Tree Trunk
    canvas.drawRect(
        Rect.fromCenter(center: Offset(size.width / 2, size.height - 100), width: 50, height: 200),
        treePaint);

    // Draw Leaves (Big Circle for Tree)
    canvas.drawCircle(Offset(size.width / 2, size.height - 200), 100, leavesPaint);

    // Draw Glowing Lights
    for (var orb in lightOrbs) {
      final Paint lightPaint = Paint()
        ..color = Colors.yellow.withOpacity(0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(orb.position, orb.radius, lightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==============================
// ✨ Animated Light Orb Class
// ==============================
class LightOrb {
  Offset position;
  double radius;
  Offset velocity;

  LightOrb({required this.position, required this.radius, required this.velocity});

  void move() {
    position += velocity;

    // Keep orbs within screen bounds
    if (position.dx < 0 || position.dx > 400) velocity = Offset(-velocity.dx, velocity.dy);
    if (position.dy < 0 || position.dy > 600) velocity = Offset(velocity.dx, -velocity.dy);
  }
}