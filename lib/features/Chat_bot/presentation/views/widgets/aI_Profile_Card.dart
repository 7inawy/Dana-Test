import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';

class AIProfileCard extends StatelessWidget {
  const AIProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80.w,
          height: 80.w,
          child: CircleAvatar(backgroundImage: AssetImage(AppAssets.aiAvatar)),
        ),
        SizedBox(height: 16.h),
        Text(
          AppLocalizations.of(context)!.aiAssistantName,
          style: AppTextStyle.semibold20TextHeading(context),
        ),
      ],
    );
  }
}
