import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';

class AIChatAppBar extends StatelessWidget {
  const AIChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircleAvatar(
              backgroundImage: AssetImage(AppAssets.aiAvatar),
            ),
          ),
          SizedBox(width: AppRadius.space_md),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.aiAssistantName,
              style: AppTextStyle.medium16TextHeading(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          CustomAppBarButton(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
