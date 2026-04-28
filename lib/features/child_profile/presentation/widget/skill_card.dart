import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/data/model/skill_card_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final surface = isDark
        ? AppColors.bg_surface_subtle_dark
        : AppColors.bg_surface_subtle_light;

    final card = CustomFrame(
      width: 172.w,
      vPadding: 12.h,
      hPadding: 12.w,
      color: surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.bg_card_default_dark
                  : AppColors.bg_card_default_light,
              borderRadius: BorderRadius.circular(AppRadius.radius_full),
              border: Border.all(
                color: isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light,
                width: AppRadius.stroke_thin,
              ),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              data.iconSrc,
              width: 20.w,
              height: 20.w,
              colorFilter: ColorFilter.mode(
                isDark
                    ? AppColors.icon_onLight_dark
                    : AppColors.icon_onLight_light,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyle.semibold16TextHeading(context),
          ),
          if (data.subtitle.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              data.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyle.medium12TextBody(context),
            ),
          ],
          const Spacer(),
          SizedBox(height: 12.h),
          Row(
            textDirection: TextDirection.ltr,
            children: [
              CustomAppBarButton(
                width: 28.w,
                height: 28.w,
                iconPadding: 6.w,
                onTap: onTap ?? () {},
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.medium10TextBody(context),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.count,
                        style: AppTextStyle.semibold16Secondary(context),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        context.l10n.skill,
                        style: AppTextStyle.regular12TextBody(context),
                      ),
                    ],
                  ),
                ],
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
