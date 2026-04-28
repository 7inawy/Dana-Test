import 'package:dana/core/widgets/custom_text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_language_provider.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChangeLanguageBottomSheet extends StatefulWidget {
  const ChangeLanguageBottomSheet({super.key});

  @override
  State<ChangeLanguageBottomSheet> createState() =>
      _ChangeLanguageBottomSheetState();
}

class _ChangeLanguageBottomSheetState extends State<ChangeLanguageBottomSheet> {
  int selectedLanguage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lang = context.read<AppLanguageProvider>().appLanguage;

      setState(() {
        selectedLanguage = lang == 'ar' ? 0 : 1;
      });
    });
  }

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
              context.l10n.languageTitle,
              style: AppTextStyle.medium20TextDisplay(context),
            ),

            SizedBox(height: 8.h),

            Text(
              context.l10n.languageDesc,
              style: AppTextStyle.regular16TextBody(context),
            ),

            SizedBox(height: 24.h),

            CustomTextFrame(
              text: context.l10n.arabicLanguage,
              isSelectable: true,
              isSelected: selectedLanguage == 0,
              preIconSrc: 'assets/Icons/profile/arabic_icon.svg',
              preIconBackgroundColor: isDark
                  ? AppColors.primary_50_dark
                  : AppColors.primary_50_light,
              preIconColor: isDark
                  ? const Color.fromARGB(255, 63, 157, 168)
                  : AppColors.icon_onLight_light,
              onTap: () {
                setState(() {
                  selectedLanguage = 0;
                });

                context.read<AppLanguageProvider>().changeLanguage('ar');
              },
            ),

            SizedBox(height: 12.h),

            CustomTextFrame(
              text: context.l10n.englishLanguage,
              isSelectable: true,
              isSelected: selectedLanguage == 1,
              preIconSrc: 'assets/Icons/profile/english_icon.svg',
              preIconBackgroundColor: isDark
                  ? AppColors.primary_50_dark
                  : AppColors.primary_50_light,
              preIconColor: isDark
                  ? const Color.fromARGB(255, 63, 157, 168)
                  : AppColors.icon_onLight_light,
              onTap: () {
                setState(() {
                  selectedLanguage = 1;
                });

                context.read<AppLanguageProvider>().changeLanguage('en');
              },
            ),

            SizedBox(height: 167.h),
          ],
        ),
      ),
    );
  }
}
