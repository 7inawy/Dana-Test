import 'package:dana/core/widgets/Custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';

class SignUpIndicatorRow extends StatelessWidget {
  final int currentIndex;

  const SignUpIndicatorRow({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.h4),
          child: CustomIndicator(active: index == currentIndex),
        ),
      ),
    );
  }
}
