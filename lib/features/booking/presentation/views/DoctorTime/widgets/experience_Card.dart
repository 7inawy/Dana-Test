import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ExperienceCard extends StatelessWidget {
  final String textOne;
  // final IconData icon;
  final String textTwo;
  final String svgPicture;

  const ExperienceCard({
    super.key,
    required this.textOne,
    required this.textTwo,
    required this.svgPicture,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            width: 0.8.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark
                    ? AppColors.button_primary_default_dark
                    : AppColors.button_primary_default_light,
                child: SvgPicture.asset(
                  svgPicture,
                  width: 22.w,
                  height: 22.h,
                  colorFilter: ColorFilter.mode(
                    isDark
                        ? AppColors.icon_onDark_dark
                        : AppColors.icon_onDark_light,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textOne,
                    style: AppTextStyle.semibold16TextHeading(context),
                  ),
                  Text(textTwo, style: AppTextStyle.bold12TextBody(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
