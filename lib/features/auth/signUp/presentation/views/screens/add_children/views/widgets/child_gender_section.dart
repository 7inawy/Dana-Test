import 'package:dana/core/widgets/custom_toggle_selector.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';

class ChildGenderSection extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ChildGenderSection({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.childGender,
          style: AppTextStyle.medium12TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        CustomToggleSelector(
          firstText: context.l10n.boy,
          secondText: context.l10n.girl,
          onChanged: onSelect,
        ),
      ],
    );
  }
}
