import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_theme_provider.dart';

class CustomIndicator extends StatelessWidget {
  final bool active;
  final double? activeWidth;
  final double? inactiveWidth;
  final double? height;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomIndicator({
    super.key,
    required this.active,
    this.activeWidth,
    this.inactiveWidth,
    this.height,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return AnimatedContainer(
      width: active
          ? (activeWidth ?? AppSizes.w86)
          : (inactiveWidth ?? AppSizes.w86),
      height: height ?? AppSizes.h5,
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: active
            ? (activeColor ??
                  (isDark
                      ? AppColors.secondary_default_dark
                      : AppColors.secondary_default_light))
            : (inactiveColor ??
                  (isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light)),
      ),
    );
  }
}

class CustomIndicatorRow extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final double? activeWidth;
  final double? inactiveWidth;
  final double? height;
  final double spacing;

  const CustomIndicatorRow({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    this.activeWidth,
    this.inactiveWidth,
    this.height,
    this.spacing = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: CustomIndicator(
            active: currentIndex == index,
            activeWidth: activeWidth,
            inactiveWidth: inactiveWidth,
            height: height,
          ),
        ),
      ),
    );
  }
}
