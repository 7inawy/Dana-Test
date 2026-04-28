import 'package:dana/core/utils/app_raduis.dart';
import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;

  const DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    const dashH = 12;
    const gap = 8;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, (y + dashH).clamp(0, size.height)),
        paint,
      );
      y += dashH + gap;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter old) => color != old.color;
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  const DashedRectPainter({required this.color, this.radius = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppRadius.stroke_thin
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(AppRadius.radius_sm),
        ),
      );

    const dashW = 8;
    const gap = 10;
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(
          metric.extractPath(d, (d + dashW).clamp(0, metric.length)),
          paint,
        );
        d += dashW + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedRectPainter old) => color != old.color;
}
