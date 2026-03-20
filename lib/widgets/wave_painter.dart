import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top light grey wave
    var paint = Paint()
      ..color = const Color(0xFFF0F4F8)
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.35, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);

    // Bottom blue accent wave
    var bluePaint = Paint()
      ..color = const Color(0xFF4A90E2).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    var bluePath = Path();
    bluePath.moveTo(0, size.height * 0.8);
    bluePath.quadraticBezierTo(size.width * 0.5, size.height * 0.75, size.width, size.height * 0.9);
    bluePath.lineTo(size.width, size.height);
    bluePath.lineTo(0, size.height);
    canvas.drawPath(bluePath, bluePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}