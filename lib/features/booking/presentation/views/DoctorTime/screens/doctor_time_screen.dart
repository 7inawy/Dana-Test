import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/logic/appointment_controller.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_date_row.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_month_navigator.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_time_grid.dart';
import 'package:dana/features/booking/presentation/views/DoctorTime/widgets/experience_Card.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/booking/presentation/views/DoctorTime/widgets/doctor_card.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:dana/App_style/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DoctorTimeScreen extends StatefulWidget {
  static const String routeName = 'DoctorTimeScreen';

  const DoctorTimeScreen({super.key});

  @override
  State<DoctorTimeScreen> createState() => _DoctorTimeScreenState();
}

class _DoctorTimeScreenState extends State<DoctorTimeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch latest availability (including booked slots) once.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = context.read<AppointmentController>();
      c.refreshDoctorAvailability();
      final sel = c.selectedDate;
      if (sel != null) {
        c.refreshAvailableSlotsForDate(sel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppointmentController>();
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final ratingsCount = controller.ratingQuantity > 0
        ? controller.ratingQuantity.toString()
        : '—';
    final patientsCount = (controller.totalPatients != null &&
            controller.totalPatients! > 0)
        ? controller.totalPatients.toString()
        : '—';
    final experience = controller.experienceYears > 0
        ? controller.experienceYears.toString()
        : '—';
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(24.r),
        child: CustomButton(
          onTap: () async {
            if (!controller.hasDoctor) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('اختر طبيباً من قائمة الأطباء أولاً'),
                ),
              );
              return;
            }
            if (!controller.canProceedToPayment) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.selectAppointment)),
              );
              return;
            }
            final draft = controller.buildDraftForPayment();
            if (draft != null) {
              await Navigator.of(
                context,
              ).pushNamed(AppRoutes.paymentMethod, arguments: draft);
              if (!mounted) return;
              // After returning from booking/payment flow, refresh slots to reflect
              // any changes made by other parents while we were away.
              await controller.refreshDoctorAvailability();
              final sel = controller.selectedDate;
              if (sel != null) {
                await controller.refreshAvailableSlotsForDate(sel);
              }
            }
          },
          text: context.l10n.nextButton,
        ),
      ),
      body: Stack(
        children: [
          Image.asset(AppAssets.doctorTime, fit: BoxFit.fill),
          Positioned.directional(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            top: 30.h,
            end: 24.w,
            child: CustomAppBarButton(
              width: 36.w,
              height: 36.h,
              borderRadius: AppRadius.radius_full,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.bg_surface_default_dark
                      : AppColors.bg_surface_default_light,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(bottom: 80.h),
                  children: [
                    Center(child: HomeIndicator()),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.bg_surface_default_dark
                            : AppColors.bg_surface_default_light,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Consumer<AppThemeProvider>(
                        builder: (context, appTheme, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 16.h),
                            const DoctorCard(),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                ExperienceCard(
                                  textOne: ratingsCount,
                                  textTwo: 'التقييم',
                                  svgPicture: 'assets/Icons/medal_star.svg',
                                ),
                                SizedBox(width: 8.w),
                                ExperienceCard(
                                  textOne: patientsCount,
                                  textTwo: context.l10n.patients,
                                  svgPicture: 'assets/Icons/people.svg',
                                ),
                                SizedBox(width: 8.w),
                                ExperienceCard(
                                  textOne: experience,
                                  textTwo: context.l10n.yearsExperience,
                                  svgPicture: 'assets/Icons/ranking.svg',
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            AppointmentMonthNavigator(
                              currentMonth: controller.currentMonth,
                              onPrevious: controller.goToPreviousMonth,
                              onNext: controller.goToNextMonth,
                            ),
                            SizedBox(height: 12.h),
                            AppointmentDateRow(
                              dates: controller.dateList,
                              selectedDate: controller.selectedDate,
                              isDisabled: controller.isDateFullyBooked,
                              onSelected: controller.selectDate,
                            ),
                            SizedBox(height: 24.h),
                            AppointmentTimeGrid(
                              times: controller.timeSlots,
                              selectedIndex: controller.selectedTimeIndex,
                              isBooked: controller.isTimeBooked,
                              onSelected: controller.selectTime,
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
