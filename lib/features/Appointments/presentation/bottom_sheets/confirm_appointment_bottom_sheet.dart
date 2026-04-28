import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/widgets/booking_summary_card.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/widgets/patient_header_card.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ConfirmAppointmentBottomSheet extends StatelessWidget {
  const ConfirmAppointmentBottomSheet({super.key});

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
            CustomScreenHeader(
              title: context.l10n.reviewBookingTitle,
              subtitle: context.l10n.reviewBookingDesc,
            ),

            SizedBox(height: 24.h),
            BookingSummaryCard(isDark: isDark),
            SizedBox(height: 12.h),
            PatientHeaderCard(isDark: isDark),
            SizedBox(height: 40.h),
            CustomButton(
              text: context.l10n.confirmBooking,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
