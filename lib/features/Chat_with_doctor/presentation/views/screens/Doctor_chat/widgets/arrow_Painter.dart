import 'package:flutter/cupertino.dart';

class ArrowPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isRtl;

  const ArrowPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (isRtl) {
      path
        ..moveTo(size.width * 0.65, size.height * 0.25)
        ..lineTo(size.width * 0.35, size.height * 0.5)
        ..lineTo(size.width * 0.65, size.height * 0.75);
    } else {
      path
        ..moveTo(size.width * 0.35, size.height * 0.25)
        ..lineTo(size.width * 0.65, size.height * 0.5)
        ..lineTo(size.width * 0.35, size.height * 0.75);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ArrowPainter old) =>
      old.color != color || old.isRtl != isRtl;
}
