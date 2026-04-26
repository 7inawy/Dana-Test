import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/currency_helper.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/features/booking/data/repo/booking_repo.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/widgets/booking_summary_card.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/widgets/patient_header_card.dart';
import 'package:dana/features/parent_profile/data/repo/parent_profile_repository.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

String _bookingErrorMessage(Object e) {
  if (e is DioException) {
    final d = e.response?.data;
    if (d is Map) {
      final m = d['message']?.toString();
      if (m != null && m.isNotEmpty) {
        final lower = m.toLowerCase();
        if (lower.contains('already booked') || lower.contains('date already booked')) {
          return 'هذا الموعد تم حجزه بالفعل. اختر وقتًا آخر.';
        }
        return m;
      }
      final resp = d['response'];
      if (resp is Map) {
        final m2 = resp['message']?.toString();
        if (m2 != null && m2.isNotEmpty) {
          final lower = m2.toLowerCase();
          if (lower.contains('already booked') || lower.contains('date already booked')) {
            return 'هذا الموعد تم حجزه بالفعل. اختر وقتًا آخر.';
          }
          return m2;
        }
        final data = resp['data'];
        if (data is Map) {
          final m3 = data['message']?.toString();
          if (m3 != null && m3.isNotEmpty) {
            final lower = m3.toLowerCase();
            if (lower.contains('already booked') || lower.contains('date already booked')) {
              return 'هذا الموعد تم حجزه بالفعل. اختر وقتًا آخر.';
            }
            return m3;
          }
        }
      }
    }
    return e.message?.isNotEmpty == true ? e.message! : e.toString();
  }
  return e.toString();
}

class PaymentSuccessScreen extends StatefulWidget {
  static const String routeName = 'PaymentSuccessScreen';

  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  BookingDraft? _draft;
  bool _submitting = false;
  String? _createdBookingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final a = ModalRoute.of(context)?.settings.arguments;
    if (_draft == null && a is BookingDraft) {
      _draft = a;
    }
  }

  Future<void> _submitBooking() async {
    final draft = _draft;
    if (draft == null || !draft.canSubmit) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('بيانات الحجز غير مكتملة')));
      return;
    }
    setState(() => _submitting = true);
    try {
      final me = await sl<ParentProfileRepository>().getMe();
      final parentId = me.id;
      final detectionPrice =
          (draft.doctor.detectionPrice > 0 ? draft.doctor.detectionPrice : 250)
              .round();
      final result = await sl<BookingRepo>().createBooking(
        doctorId: draft.doctor.doctorId,
        parentId: parentId,
        childId: draft.childId!,
        date: draft.dateIso,
        time: draft.timeHm,
        paymentMethod: draft.paymentMethod!,
        visitStatus: draft.visitStatus,
        detectionPrice: detectionPrice,
        notes: draft.notes,
      );
      if (!mounted) return;
      if (result.isPaymentRequired &&
          result.paymentUrl != null &&
          result.paymentUrl!.isNotEmpty) {
        final uri = Uri.tryParse(result.paymentUrl!);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        return;
      }
      final id = result.booking?.id ?? '';
      setState(() => _createdBookingId = id.isNotEmpty ? id : null);
      showConfirmationSheet();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_bookingErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final draft = _draft;
    if (draft == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              'لا يوجد حجز للعرض.',
              style: AppTextStyle.medium16TextHeading(context),
            ),
          ),
        ),
      );
    }

    final isOnVisit = draft.paymentMethod == 'on-visit';
    final fee = draft.doctor.detectionPrice > 0
        ? draft.doctor.detectionPrice
        : 250;
    final feeLabel = CurrencyHelper.format(context, fee);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(24.r),
        child: CustomButton(
          onTap: _submitting ? () {} : _submitBooking,
          text: _submitting
              ? context.l10n.confirming
              : context.l10n.confirmBooking,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 32.h, right: 24.w, left: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomScreenHeader(
              title: context.l10n.reviewBookingTitle,
              subtitle: context.l10n.reviewBookingSubtitle,
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingSummaryCard(
                      isDark: isDark,
                      draft: draft,
                      bookingDisplayId: _createdBookingId,
                    ),
                    SizedBox(height: 12.h),
                    if (draft.childName != null)
                      PatientHeaderCard(
                        isDark: isDark,
                        childName: draft.childName!,
                        childYears: draft.childYears ?? 0,
                      ),
                    SizedBox(height: 24.h),
                    Text(
                      isOnVisit
                          ? context.l10n.payOnVisit
                          : context.l10n.electronicPayment,
                      style: AppTextStyle.bold16TextDisplay(context),
                    ),
                    SizedBox(height: 12.h),
                    TextFrame(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.serviceCost,
                                style: AppTextStyle.bold12TextHeading(context),
                              ),
                              Text(
                                feeLabel,
                                style: AppTextStyle.bold12TextHeading(context),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.tax,
                                style: AppTextStyle.semibold12TextBody(context),
                              ),
                              Text(
                                CurrencyHelper.format(context, 0),
                                style: AppTextStyle.semibold12TextBody(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextFrame(
                      color: isDark
                          ? AppColors.bg_button_primary_disabled_dark
                          : AppColors.bg_button_primary_disabled_light,
                      borderColor: isDark
                          ? AppColors.border_button_primary_dark
                          : AppColors.border_button_primary_light,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.totalCost,
                            style: AppTextStyle.bold12TextDisplay(context),
                          ),
                          Text(
                            feeLabel,
                            style: AppTextStyle.semibold12TextDisplay(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showConfirmationSheet() {
    final themeProvider = context.read<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 21.h,
            left: 24.w,
            right: 24.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 134.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    color: isDark
                        ? AppColors.border_card_default_dark
                        : AppColors.border_card_default_light,
                  ),
                ),
                SizedBox(height: 28.h),
                Image.asset(
                  width: 150.w,
                  height: 150.h,
                  'assets/Images/result page success motion design 1.png',
                ),
                Text(
                  context.l10n.bookingConfirmed,
                  style: AppTextStyle.bold20TextDisplay(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.l10n.bookingSuccessMessageOnVisit,
                  style: AppTextStyle.bold16TextBody(context),
                ),
                SizedBox(height: 32.h),
                CustomButton(
                  text: context.l10n.done,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.appointments,
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
