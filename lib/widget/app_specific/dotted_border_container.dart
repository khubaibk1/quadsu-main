import 'dart:ui';

import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double? strokeWidth;
  final double? dotSpacing;
  final double? radius;

  DottedBorderPainter({
    required this.color,
     this.strokeWidth=2,
     this.dotSpacing=6,
     this.radius=15,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth!
      ..style = PaintingStyle.stroke;

    final borderPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius!),
      ));

    PathMetric pathMetric = borderPath.computeMetrics().first;
    double dashWidth = dotSpacing! / 2;
    double dashSpace = dotSpacing! / 2;
    double distance = 0.0;

    while (distance < pathMetric.length) {
      canvas.drawPath(
        pathMetric.extractPath(distance, distance + dashWidth),
        paint,
      );
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}