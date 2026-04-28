import 'package:dana/core/widgets/custom_date_picker.dart';
import 'package:dana/core/widgets/custom_textForm.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';

class ChildInfoFormFields extends StatefulWidget {
  const ChildInfoFormFields({
    super.key,
    required this.childNameController,
    required this.onBirthDateChanged,
  });

  final TextEditingController childNameController;
  final ValueChanged<DateTime> onBirthDateChanged;

  @override
  State<ChildInfoFormFields> createState() => _ChildInfoFormFieldsState();
}

class _ChildInfoFormFieldsState extends State<ChildInfoFormFields> {
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  int ageYears = 0;
  int ageMonths = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextForm(
          text: context.l10n.childNameLabel,
          hintText: context.l10n.childNameHint,
          keyboardType: TextInputType.name,
          controller: widget.childNameController,
        ),
        SizedBox(height: AppSizes.h16),

        CustomDatePicker(
          controller: _ageController,
          onChanged: (birthDate, years, months) {
            widget.onBirthDateChanged(birthDate);
            setState(() {
              ageYears = years;
              ageMonths = months;
            });
          },
        ),
      ],
    );
  }
}
