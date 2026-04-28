import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';

class CustomToggleSelector extends StatefulWidget {
  const CustomToggleSelector({
    super.key,
    required this.firstText,
    required this.secondText,
    this.initialIndex = 1,
    required this.onChanged,
    this.firstContent,
    this.secondContent,
  });

  final String firstText;
  final String secondText;
  final int initialIndex;
  final Function(int) onChanged;
  final Widget? firstContent;
  final Widget? secondContent;

  @override
  State<CustomToggleSelector> createState() => _CustomToggleSelectorState();
}

class _CustomToggleSelectorState extends State<CustomToggleSelector> {
  late int localSelectedIndex;

  @override
  void initState() {
    super.initState();
    localSelectedIndex = widget.initialIndex;
  }

  void updateIndex(int index) {
    setState(() {
      localSelectedIndex = index;
    });
    widget.onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.bg_card_default_dark
                : AppColors.bg_card_default_light,
            border: Border.all(
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
              width: AppRadius.stroke_thin,
            ),
            borderRadius: BorderRadius.circular(AppRadius.radius_sm),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppRadius.radius_xs),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => updateIndex(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: localSelectedIndex == 1
                            ? (isDark
                                  ? AppColors.primary_50_dark
                                  : AppColors.primary_50_light)
                            : (isDark
                                  ? AppColors.bg_card_default_dark
                                  : AppColors.bg_card_default_light),
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius_xs,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          widget.firstText,
                          style: localSelectedIndex == 1
                              ? AppTextStyle.medium16TextHeading(
                                  context,
                                ).copyWith(
                                  color: isDark
                                      ? AppColors.text_heading_dark
                                      : AppColors.text_heading_light,
                                )
                              : AppTextStyle.regular16TextBody(
                                  context,
                                ).copyWith(
                                  color: isDark
                                      ? AppColors.text_heading_dark
                                      : AppColors.text_heading_light,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => updateIndex(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: localSelectedIndex == 0
                            ? (isDark
                                  ? AppColors.primary_50_dark
                                  : AppColors.primary_50_light)
                            : (isDark
                                  ? AppColors.bg_card_default_dark
                                  : AppColors.bg_card_default_light),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          widget.secondText,
                          style: localSelectedIndex == 0
                              ? AppTextStyle.medium16TextHeading(
                                  context,
                                ).copyWith(
                                  color: isDark
                                      ? AppColors.text_heading_dark
                                      : AppColors.text_heading_light,
                                )
                              : AppTextStyle.regular16TextBody(
                                  context,
                                ).copyWith(
                                  color: isDark
                                      ? AppColors.text_heading_dark
                                      : AppColors.text_heading_light,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (widget.firstContent != null && widget.secondContent != null)
          SizedBox(height: 12.h),

        if (widget.firstContent != null && widget.secondContent != null)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: localSelectedIndex == 1
                ? widget.firstContent!
                : widget.secondContent!,
          ),
      ],
    );
  }
}
