import 'package:flutter/material.dart';

class VerticalLine extends StatelessWidget {
  final Color color;
  final bool isDashed;

  const VerticalLine({super.key, required this.color, this.isDashed = false});

  @override
  Widget build(BuildContext context) {
    if (!isDashed) {
      return Container(width: 2, color: color);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        const dashHeight = 6.0;
        const dashSpace = 4.0;

        int dashCount = (height / (dashHeight + dashSpace)).floor();

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(width: 2, height: dashHeight, color: color);
          }),
        );
      },
    );
  }
}
