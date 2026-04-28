import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/video_Model.dart';

class VideoInfoWidget extends StatelessWidget {
  final VideoModel video;

  const VideoInfoWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

    final views = (video.views ?? 125908).toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        borderRadius: BorderRadius.circular(AppRadius.radius_lg),
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            width: AppRadius.stroke_thin,
          ),
        ),
      ),
      padding: EdgeInsets.all(AppRadius.space_lg),
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 360.w,
            child: Text(
              video.title,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: AppTextStyle.semibold24TextHeading(context),
            ),
          ),
          SizedBox(height: AppRadius.space_md),
          SizedBox(
            width: 360.w,
            child: Text(
              video.description ?? l10n.noDescription,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: AppTextStyle.medium12TextBody(context),
            ),
          ),
          SizedBox(height: AppRadius.space_md),

          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.remove_red_eye,
                size: 14.w,
                color: isDark
                    ? AppColors.text_button_disabled_dark
                    : AppColors.text_button_disabled_light,
              ),
              SizedBox(width: 4.w),
              Text(
                isRtl ? '$views ${l10n.views}' : '${l10n.views} $views',
                style: AppTextStyle.regular12TextBody(context).copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: isDark
                      ? AppColors.text_button_disabled_dark
                      : AppColors.text_button_disabled_light,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
