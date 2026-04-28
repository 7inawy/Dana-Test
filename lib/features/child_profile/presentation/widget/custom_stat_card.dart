import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CustomStatCard extends StatelessWidget {
  const CustomStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.iconPath,
    this.color,
    this.changeColor,
  });

  final String title;
  final String iconPath;
  final String value;
  final String change;
  final Color? color;
  final Color? changeColor;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Expanded(
      child: CustomFrame(
        hPadding: 8.w,
        vPadding: 12.h,
        color:
            color ??
            (isDark
                ? AppColors.bg_surface_subtle_dark
                : AppColors.bg_surface_subtle_light),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    width: 16.w,
                    colorFilter: ColorFilter.mode(
                      isDark
                          ? AppColors.icon_onLight_dark
                          : AppColors.icon_onLight_light,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: AppTextStyle.medium10TextBody(context),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              value,
              style: AppTextStyle.semibold16TextDisplay(context),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                change,
                style: changeColor == null
                    ? AppTextStyle.medium8Succes(context)
                    : AppTextStyle.medium8Succes(
                        context,
                      ).copyWith(color: changeColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
