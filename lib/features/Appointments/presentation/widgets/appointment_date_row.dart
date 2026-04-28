import 'package:dana/features/Appointments/presentation/widgets/Date_Card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AppointmentDateRow extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelected;
  final bool Function(DateTime date)? isDisabled;

  const AppointmentDateRow({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onSelected,
    this.isDisabled,
  });

  bool _isSelected(DateTime date) {
    return selectedDate?.year == date.year &&
        selectedDate?.month == date.month &&
        selectedDate?.day == date.day;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dates.length, (index) {
          final date = dates[index];
          final disabled = isDisabled?.call(date) ?? false;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: disabled ? null : () => onSelected(date),
              child: DateCard(
                number: date.day,
                day: DateFormat.EEEE(locale).format(date),
                isSelected: _isSelected(date),
                isDisabled: disabled,
              ),
            ),
          );
        }),
      ),
    );
  }
}
