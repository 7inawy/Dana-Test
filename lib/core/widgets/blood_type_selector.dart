import 'package:dana/core/constant/blood_types.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/animated_dropdown.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';

class BloodTypeSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const BloodTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.bloodTypeLabel,
          style: AppTextStyle.medium12TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        AnimatedDropdown(
          hintText: context.l10n.bloodTypeHint,
          items: BloodTypes.list,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
