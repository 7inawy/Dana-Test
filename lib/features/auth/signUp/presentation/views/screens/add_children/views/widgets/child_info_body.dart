import 'package:dana/core/widgets/blood_type_selector.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/extensions/localization_extension.dart';

import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'child_gender_section.dart';
import 'child_info_form_fields.dart';

class ChildInfoBody extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onGenderSelect;
  final TextEditingController childNameController;
  final ValueChanged<DateTime> onBirthDateChanged;
  final ValueChanged<String?> onBloodTypeChanged;

  const ChildInfoBody({
    super.key,
    required this.selectedIndex,
    required this.onGenderSelect,
    required this.childNameController,
    required this.onBirthDateChanged,
    required this.onBloodTypeChanged,
  });

  @override
  State<ChildInfoBody> createState() => _ChildInfoBodyState();
}

class _ChildInfoBodyState extends State<ChildInfoBody> {
  String? bloodType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.h48),
            CustomScreenHeader(
              title: context.l10n.addChildTitle,
              subtitle: context.l10n.addChildDesc,
            ),
            SizedBox(height: AppSizes.h32),
            ChildInfoFormFields(
              childNameController: widget.childNameController,
              onBirthDateChanged: widget.onBirthDateChanged,
            ),
            SizedBox(height: AppSizes.h16),
            ChildGenderSection(
              selectedIndex: widget.selectedIndex,
              onSelect: widget.onGenderSelect,
            ),
            SizedBox(height: AppSizes.h16),
            BloodTypeSelector(
              value: bloodType,
              onChanged: (val) {
                setState(() {
                  bloodType = val;
                });
                widget.onBloodTypeChanged(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
