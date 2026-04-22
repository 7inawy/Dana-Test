import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_text_field.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;

  /// Called with the calendar birth date and derived age parts.
  final void Function(DateTime birthDate, int years, int months) onChanged;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late int localSelectedIndex;
  Map<String, int> _calculateAge(DateTime birthDate) {
    final now = DateTime.now();

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    if (now.day < birthDate.day) {
      months--;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return {"years": years, "months": months};
  }

  String _formatAge(BuildContext context, int years, int months) {
    final l10n = context.l10n;

    String yearText;
    if (years == 1) {
      yearText = l10n.yearSingular;
    } else if (years == 2) {
      yearText = l10n.yearDual;
    } else {
      yearText = l10n.yearPlural(years);
    }

    String monthText;
    if (months == 1) {
      monthText = l10n.monthSingular;
    } else if (months == 2) {
      monthText = l10n.monthDual;
    } else {
      monthText = l10n.monthPlural(months);
    }

    if (years > 0 && months > 0) {
      return "$yearText ${l10n.and} $monthText";
    } else if (years > 0) {
      return yearText;
    } else {
      return monthText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.birthDateLabel,
          style: AppTextStyle.medium12TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        CustomTextField(
          controller: widget.controller,
          hintText: context.l10n.birthDateHint,
          readOnly: true,
          icon: Icons.calendar_month_rounded,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              locale: Localizations.localeOf(context),
            );

            if (pickedDate != null) {
              final age = _calculateAge(pickedDate);

              final years = age["years"]!;
              final months = age["months"]!;

              widget.controller.text = _formatAge(context, years, months);

              widget.onChanged(pickedDate, years, months);
            }
          },
        ),
      ],
    );
  }
}
