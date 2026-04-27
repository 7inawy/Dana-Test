import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/presentation/appointment_rebook_args.dart';
import 'package:dana/features/Appointments/presentation/widgets/rating_card.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/widgets/doctor_details_widget.dart';
import 'package:dana/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:dana/features/booking/presentation/cubit/booking_state.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RateDoctorBottomSheet extends StatefulWidget {
  final Appointment appointment;

  const RateDoctorBottomSheet({super.key, required this.appointment});

  @override
  State<RateDoctorBottomSheet> createState() => _RateDoctorBottomSheetState();
}

class _RateDoctorBottomSheetState extends State<RateDoctorBottomSheet> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = rating > 0;
    final a = widget.appointment;
    final doctorForSheet = ratingDoctorArgsFromAppointment(a);
    final subtitleName = doctorForSheet.doctorName.trim().isNotEmpty
        ? '${context.l10n.dr} ${doctorForSheet.doctorName.trim()}'
        : a.doctorName.trim();

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
              title: context.l10n.rateDoctorTitle,
              subtitle: context.l10n.rateDoctorDesc(subtitleName),
            ),
            SizedBox(height: 24.h),
            CustomFrame(
              vPadding: 12.h,
              child: DoctorDetailsWidget(doctor: doctorForSheet),
            ),
            SizedBox(height: 12.h),
            RateCard(
              onRatingChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            SizedBox(height: 40.h),
            CustomButton(
              color: isButtonEnabled
                  ? (isDark
                        ? AppColors.button_primary_default_dark
                        : AppColors.button_primary_default_light)
                  : (isDark
                        ? AppColors.bg_button_primary_disabled_dark
                        : AppColors.bg_button_primary_disabled_light),
              text: context.l10n.sendRating,
              textColor: isButtonEnabled
                  ? (isDark
                        ? AppColors.text_button_dark
                        : AppColors.text_button_light)
                  : (isDark
                        ? AppColors.text_button_disabled_dark
                        : AppColors.text_button_disabled_light),
              borderColor: isButtonEnabled
                  ? (isDark
                        ? AppColors.border_button_primary_dark
                        : AppColors.border_button_primary_light)
                  : (isDark
                        ? AppColors.bg_button_primary_disabled_dark
                        : AppColors.bg_button_primary_disabled_light),
              onTap: () async {
                if (!isButtonEnabled) return;
                final bookingId = widget.appointment.bookingId;
                if (bookingId == null || bookingId.isEmpty) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.ratingSubmitFailed),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                await context.read<BookingCubit>().rateBooking(
                  bookingId: bookingId,
                  rating: rating,
                  parentId: widget.appointment.parentId,
                );
                if (!mounted) return;
                final st = context.read<BookingCubit>().state;
                if (st is BookingError) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        st.error.isNotEmpty
                            ? st.error
                            : context.l10n.ratingSubmitFailed,
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
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
