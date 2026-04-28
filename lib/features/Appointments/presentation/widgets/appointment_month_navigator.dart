import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dana/features/Appointments/logic/appointment_calendar_logic.dart';

class AppointmentMonthNavigator extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const AppointmentMonthNavigator({
    super.key,
    required this.currentMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final isCurrentMonth = AppointmentCalendarLogic.isCurrentMonth(
      currentMonth,
    );
    final iconColor = isDark
        ? AppColors.icon_onLight_dark
        : AppColors.icon_onLight_light;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.selectAppointment,
          style: AppTextStyle.bold16TextDisplay(context),
        ),
        Row(
          children: [
            if (!isCurrentMonth)
              GestureDetector(
                onTap: onPrevious,
                child: Icon(
                  isRtl
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 16.r,
                  color: iconColor,
                ),
              ),
            SizedBox(width: 3.w),
            Text(
              DateFormat.MMMM(
                Localizations.localeOf(context).languageCode,
              ).format(currentMonth),
              style: AppTextStyle.bold12TextBody(context),
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: onNext,
              child: Icon(
                isRtl
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: 16.r,
                color: iconColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
