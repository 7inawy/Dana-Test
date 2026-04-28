import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/data/model/skill_card_model.dart';
import 'package:dana/features/child_profile/presentation/widget/custom_progress_bar.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({super.key, required this.data, this.onTap});

  final SkillCardData data;

  /// Opens checklist / detail; matches tappable [CustomStatCard]-style cards.
  final VoidCallback? onTap;

  int get _progressPercent {
    final t = data.progressTotal;
    if (t <= 0) return 0;
    return ((data.progressDone * 100) / t).round().clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    final surface = isDark
        ? AppColors.bg_surface_subtle_dark
        : AppColors.bg_surface_subtle_light;

    final card = CustomFrame(
      width: 160.w,
      vPadding: 12.h,
      hPadding: 10.w,
      color: surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.bg_card_default_dark
                      : AppColors.bg_card_default_light,
                  borderRadius: BorderRadius.circular(AppRadius.radius_md),
                  border: Border.all(
                    color: isDark
                        ? AppColors.border_card_default_dark
                        : AppColors.border_card_default_light,
                    width: AppRadius.stroke_thin,
                  ),
                ),
                child: SvgPicture.asset(
                  data.iconSrc,
                  colorFilter: ColorFilter.mode(
                    isDark
                        ? AppColors.icon_onLight_dark
                        : AppColors.icon_onLight_light,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: AppTextStyle.medium12TextHeading(context),
          ),
          if (data.subtitle.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              data.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: AppTextStyle.regular8TextBody(context),
            ),
          ],
          SizedBox(height: 8.h),
          CustomProgressBar(value: _progressPercent),
          const Spacer(),
          SizedBox(height: 8.h),
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Text(
                data.count,
                style: AppTextStyle.semibold16TextDisplay(context),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  context.l10n.skill,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: AppTextStyle.medium10TextBody(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radius_lg),
        child: card,
      ),
    );
  }
}
