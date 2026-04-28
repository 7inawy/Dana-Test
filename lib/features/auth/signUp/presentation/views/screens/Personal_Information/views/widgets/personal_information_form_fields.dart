import 'package:dana/core/constant/governorates.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/animated_dropdown.dart';
import 'package:dana/core/widgets/custom_textForm.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/l10n/app_localizations.dart';

class PersonalInformationFormFields extends StatefulWidget {
  const PersonalInformationFormFields({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.government,
    required this.onGovernmentChanged,
  });

  final TextEditingController nameController;
  final TextEditingController addressController;
  final String? government;
  final ValueChanged<String?> onGovernmentChanged;

  @override
  State<PersonalInformationFormFields> createState() =>
      _PersonalInformationFormFieldsState();
}

class _PersonalInformationFormFieldsState
    extends State<PersonalInformationFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextForm(
          text: AppLocalizations.of(context)!.fullNameLabel,
          hintText: AppLocalizations.of(context)!.fullNameHint,
          keyboardType: TextInputType.name,
          borderWidth: AppRadius.stroke_regular,
          controller: widget.nameController,
        ),
        SizedBox(height: AppSizes.h8),
        Text(
          context.l10n.governorateLabel,
          style: AppTextStyle.medium12TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        AnimatedDropdown(
          hintText: context.l10n.governorateHint,
          items: Governorates.egypt,
          value: widget.government,
          onChanged: widget.onGovernmentChanged,
        ),
        SizedBox(height: AppSizes.h8),
        CustomTextForm(
          text: AppLocalizations.of(context)!.addressLabel,
          hintText: AppLocalizations.of(context)!.addressHint,
          borderWidth: AppRadius.stroke_regular,
          keyboardType: TextInputType.streetAddress,
          controller: widget.addressController,
        ),
      ],
    );
  }
}
