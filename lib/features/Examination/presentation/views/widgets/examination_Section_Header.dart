import 'package:dana/core/utils/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';

class ExaminationSectionHeader extends StatelessWidget {
  const ExaminationSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sectionHeaderTitle,
          style: AppTextStyle.medium16TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        Text(
          l10n.sectionHeaderSubtitle,
          style: AppTextStyle.medium12TextBody(context),
        ),
      ],
    );
  }
}
