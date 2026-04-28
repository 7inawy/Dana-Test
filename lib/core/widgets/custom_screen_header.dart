import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

///دي ويدجيت بتاع اول اتنين  تيكستف كل اسكرينه
class CustomScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const CustomScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.medium20TextDisplay(context)),
        SizedBox(height: AppSizes.h8),
        Text(subtitle, style: AppTextStyle.regular16TextBody(context)),
      ],
    );
  }
}
