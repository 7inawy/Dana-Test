import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/utils/date_formatter.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/presentation/widgets/Time_Card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentTimeGrid extends StatelessWidget {
  final List<TimeOfDay> times;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool Function(TimeOfDay t)? isBooked;

  const AppointmentTimeGrid({
    super.key,
    required this.times,
    required this.selectedIndex,
    required this.onSelected,
    this.isBooked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.availableTime,
          style: AppTextStyle.bold16TextDisplay(context),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(times.length, (index) {
            final booked = isBooked?.call(times[index]) ?? false;
            return GestureDetector(
              onTap: booked ? null : () => onSelected(index),
              child: TimeCard(
                textTime: formatSingleTime(context, times[index]),
                isSelected: selectedIndex == index,
                isDisabled: booked,
              ),
            );
          }),
        ),
      ],
    );
  }
}
