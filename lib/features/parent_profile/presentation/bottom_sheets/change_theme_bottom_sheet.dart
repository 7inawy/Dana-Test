import 'package:dana/core/widgets/custom_text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChangeThemeBottomSheet extends StatefulWidget {
  const ChangeThemeBottomSheet({super.key});

  @override
  State<ChangeThemeBottomSheet> createState() => _ChangeThemeBottomSheetState();
}

class _ChangeThemeBottomSheetState extends State<ChangeThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
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
              context.l10n.themeTitle,
              style: AppTextStyle.medium20TextDisplay(context),
            ),

            SizedBox(height: 8.h),

            Text(
              context.l10n.themeDesc,
              style: AppTextStyle.regular16TextBody(context),
            ),

            SizedBox(height: 24.h),

            CustomTextFrame(
              text: context.l10n.lightMode,
              preIconSrc: 'assets/Icons/profile/theme_light_icon.svg',
              preIconBackgroundColor: isDark
                  ? AppColors.primary_50_dark
                  : AppColors.primary_50_light,
              preIconColor: isDark
                  ? const Color.fromARGB(255, 63, 157, 168)
                  : AppColors.icon_onLight_light,
              isSelectable: true,
              isSelected: themeProvider.appTheme == ThemeMode.light,
              onTap: () {
                context.read<AppThemeProvider>().changeTheme(ThemeMode.light);
              },
            ),

            SizedBox(height: 12.h),

            CustomTextFrame(
              text: context.l10n.darkMode,
              preIconSrc: 'assets/Icons/profile/theme_dark_icon.svg',
              preIconBackgroundColor: isDark
                  ? AppColors.primary_50_dark
                  : AppColors.primary_50_light,
              preIconColor: isDark
                  ? const Color.fromARGB(255, 63, 157, 168)
                  : AppColors.icon_onLight_light,
              isSelectable: true,
              isSelected: themeProvider.appTheme == ThemeMode.dark,
              onTap: () {
                context.read<AppThemeProvider>().changeTheme(ThemeMode.dark);
              },
            ),

            SizedBox(height: 12.h),

            CustomTextFrame(
              text: context.l10n.systemMode,
              preIconSrc: 'assets/Icons/profile/system_theme_icon.svg',
              preIconBackgroundColor: isDark
                  ? AppColors.primary_50_dark
                  : AppColors.primary_50_light,
              preIconColor: isDark
                  ? const Color.fromARGB(255, 63, 157, 168)
                  : AppColors.icon_onLight_light,
              isSelectable: true,
              isSelected: themeProvider.appTheme == ThemeMode.system,
              onTap: () {
                context.read<AppThemeProvider>().changeTheme(ThemeMode.system);
              },
            ),

            SizedBox(height: 91.h),
          ],
        ),
      ),
    );
  }
}
