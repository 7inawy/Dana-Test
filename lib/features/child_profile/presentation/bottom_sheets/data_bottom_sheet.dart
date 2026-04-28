import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/child_profile/presentation/bottom_sheets/confirm_data_bottom_sheet.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DataBottomSheet extends StatefulWidget {
  final String title;
  final String description;
  final List<String> items;

  const DataBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.items,
  });

  @override
  State<DataBottomSheet> createState() => _DataBottomSheetState();
}

class _DataBottomSheetState extends State<DataBottomSheet> {
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List<bool>.filled(widget.items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final bool isButtonEnabled = checked.any((element) => element);

    return Padding(
      padding: EdgeInsetsDirectional.only(
        end: 24.w,
        start: 24.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: HomeIndicator()),
            SizedBox(height: 20.h),
            Text(
              widget.title,
              style: AppTextStyle.medium20TextDisplay(context),
            ),
            SizedBox(height: 8.h),
            Text(
              widget.description,
              style: AppTextStyle.regular16TextBody(context),
            ),
            SizedBox(height: 12.h),

            for (int i = 0; i < widget.items.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    checked[i] = !checked[i];
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: checked[i]
                        ? isDark
                              ? AppColors.primary_50_dark
                              : AppColors.primary_50_light
                        : isDark
                        ? AppColors.bg_card_default_dark
                        : AppColors.bg_card_default_light,
                    borderRadius: BorderRadius.circular(AppRadius.radius_md),
                    border: Border.all(
                      color: checked[i]
                          ? isDark
                                ? AppColors.primary_default_dark
                                : AppColors.primary_default_light
                          : isDark
                          ? AppColors.border_card_default_dark
                          : AppColors.border_card_default_light,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Transform.scale(
                          scale: 1,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: isDark
                                  ? AppColors.border_card_default_dark
                                  : AppColors.border_card_default_light,
                            ),
                            child: Checkbox(
                              checkColor: isDark
                                  ? AppColors.primary_50_dark
                                  : AppColors.primary_50_light,
                              activeColor: isDark
                                  ? AppColors.primary_default_dark
                                  : AppColors.primary_default_light,
                              value: checked[i],
                              onChanged: (val) {
                                setState(() {
                                  checked[i] = val!;
                                });
                              },
                              side: BorderSide(
                                color: checked[i]
                                    ? isDark
                                          ? AppColors.primary_default_dark
                                          : AppColors.primary_default_light
                                    : isDark
                                    ? AppColors.border_card_default_dark
                                    : AppColors.border_card_default_light,
                                width: AppRadius.stroke_bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.radius_xs,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          widget.items[i],
                          style: AppTextStyle.medium16TextBody(context),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 40.h),
            CustomButton(
              color: isButtonEnabled
                  ? isDark
                        ? AppColors.button_primary_default_dark
                        : AppColors.button_primary_default_light
                  : isDark
                  ? AppColors.bg_button_primary_disabled_dark
                  : AppColors.bg_button_primary_disabled_light,
              text: context.l10n.saveProgress,
              borderColor: isDark
                  ? AppColors.bg_button_primary_disabled_dark
                  : AppColors.bg_button_primary_disabled_light,

              textStyle: isButtonEnabled
                  ? AppTextStyle.semibold16TextButton(context)
                  : AppTextStyle.semibold16TextButtonDisabled(context),
              onTap: isButtonEnabled
                  ? () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: isDark
                            ? AppColors.bg_surface_default_dark
                            : AppColors.bg_surface_default_light,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                        ),
                        builder: (_) => ConfirmDataBottomSheet(
                          firstText: context.l10n.growthConfirmTitle,
                          secondText: context.l10n.growthConfirmDesc,
                        ),
                      );
                    }
                  : () {},
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
