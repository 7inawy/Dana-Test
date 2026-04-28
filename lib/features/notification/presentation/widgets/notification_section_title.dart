import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class NotificationSectionTitle extends StatelessWidget {
  final String title;
  final bool showMarkAll;
  final String? markAllLabel;
  final VoidCallback? onMarkAll;

  const NotificationSectionTitle({
    super.key,
    required this.title,
    required this.showMarkAll,
    this.markAllLabel,
    this.onMarkAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.medium16TextHeading(context)),
        if (showMarkAll && markAllLabel != null)
          GestureDetector(
            onTap: onMarkAll,
            child: Text(
              markAllLabel!,
              style: AppTextStyle.regular12TextBody(context),
            ),
          ),
      ],
    );
  }
}
