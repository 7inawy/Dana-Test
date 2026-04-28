import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../providers/app_theme_provider.dart';

class AppointmentsTabBar extends StatelessWidget {
  final String activeTab;
  final void Function(String) onTabChanged;

  const AppointmentsTabBar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    final tabs = [
      {
        'key': 'upcoming',
        'icon': 'assets/Icons/appointments/upcoming_icon.svg',
        'label': context.l10n.appointmentsUpcoming,
      },
      {
        'key': 'completed',
        'icon': 'assets/Icons/appointments/completed_icon.svg',
        'label': context.l10n.appointmentsCompleted,
      },
      {
        'key': 'cancelled',
        'icon': 'assets/Icons/appointments/cancelled_icon.svg',
        'label': context.l10n.appointmentsCancelled,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isActive = activeTab == tab['key'];
          final isLast = index == tabs.length - 1;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: isRtl ? (isLast ? 0 : 8.w) : 0,
                right: isRtl ? 0 : (isLast ? 0 : 8.w),
              ),
              child: GestureDetector(
                onTap: () {
                  onTabChanged(tab['key'] as String);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? isDark
                              ? AppColors.primary_50_dark
                              : AppColors.primary_50_light
                        : isDark
                        ? AppColors.bg_card_default_dark
                        : AppColors.bg_card_default_light,
                    border: Border.all(
                      width: 0.6.w,
                      color: isActive
                          ? isDark
                                ? AppColors.primary_default_dark
                                : AppColors.primary_default_light
                          : isDark
                          ? AppColors.border_card_default_dark
                          : AppColors.border_card_default_light,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.radius_sm),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        tab['icon'] as String,
                        colorFilter: ColorFilter.mode(
                          isActive
                              ? isDark
                                    ? AppColors.primary_default_dark
                                    : AppColors.primary_default_light
                              : isDark
                              ? AppColors.icon_onLight_dark
                              : AppColors.icon_onLight_light,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        tab['label'] as String,
                        style: isActive
                            ? AppTextStyle.medium12TextButtonOutlined(context)
                            : AppTextStyle.medium12TextBody(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
