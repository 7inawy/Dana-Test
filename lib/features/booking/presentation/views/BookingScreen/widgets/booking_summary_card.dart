import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/utils/date_formatter.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/widgets/doctor_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.isDark,
    this.draft,
    this.bookingDisplayId,
  });

  final bool isDark;
  final BookingDraft? draft;
  final String? bookingDisplayId;

  DateTime _draftDate(BookingDraft d) {
    try {
      return DateTime.parse(d.dateIso);
    } catch (_) {
      return DateTime.now();
    }
  }

  TimeOfDay _draftTime(BookingDraft d) {
    final p = d.timeHm.split(':');
    if (p.length < 2) return const TimeOfDay(hour: 0, minute: 0);
    final h = int.tryParse(p[0]) ?? 0;
    final m = int.tryParse(p[1]) ?? 0;
    return TimeOfDay(hour: h.clamp(0, 23), minute: m.clamp(0, 59));
  }

  @override
  Widget build(BuildContext context) {
    final d = draft;
    final idLabel = bookingDisplayId != null && bookingDisplayId!.isNotEmpty
        ? '#${bookingDisplayId!.length > 8 ? bookingDisplayId!.substring(bookingDisplayId!.length - 8) : bookingDisplayId}'
        : '—';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        border: BoxBorder.all(
          color: isDark
              ? AppColors.border_card_default_dark
              : AppColors.border_card_default_light,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          DoctorDetailsWidget(doctor: d?.doctor),
          Divider(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            thickness: 1,
            radius: BorderRadius.circular(8.r),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.date,
                      style: AppTextStyle.semibold12TextHeading(context),
                    ),
                    Text(
                      d != null
                          ? formatDate(context, _draftDate(d))
                          : formatDate(context, DateTime(2026, 1, 2)),
                      style: AppTextStyle.bold12TextBody(context),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.time,
                      style: AppTextStyle.semibold12TextHeading(context),
                    ),
                    Text(
                      d != null
                          ? formatSingleTime(context, _draftTime(d))
                          : formatSingleTime(
                              context,
                              const TimeOfDay(hour: 11, minute: 0),
                            ),
                      style: AppTextStyle.bold12TextBody(context),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.bookingNumber,
                      style: AppTextStyle.semibold12TextHeading(context),
                    ),
                    Text(idLabel, style: AppTextStyle.bold12TextBody(context)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
