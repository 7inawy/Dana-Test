import 'package:dana/core/utils/app_raduis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light,
          borderRadius: BorderRadius.circular(AppRadius.radius_sm),
        ),
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          autofocus: true,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          strutStyle: const StrutStyle(forceStrutHeight: true),
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          onSubmitted: onChanged,
          style: AppTextStyle.regular12TextBody(context),
          decoration: InputDecoration(
            hintText: l10n.searchVideos,
            hintStyle: AppTextStyle.regular12TextBody(context),
            hintTextDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius_sm),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.bg_card_default_dark
                    : AppColors.bg_card_default_light,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius_sm),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius_sm),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.primary_default_dark
                    : AppColors.primary_default_light,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: ImageIcon(
                AssetImage(AppAssets.search_normal),
                color: isDark
                    ? AppColors.icon_onLight_dark
                    : AppColors.icon_onLight_light,
                size: 24.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
