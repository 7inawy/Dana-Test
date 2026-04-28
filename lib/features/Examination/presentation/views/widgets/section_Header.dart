import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../data/model/examination_model.dart';

class ExamSectionTitleHeader extends StatelessWidget {
  final ExamSection section;
  final bool showDivider;

  const ExamSectionTitleHeader({
    super.key,
    required this.section,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          text: TextSpan(
            style: AppTextStyle.semibold16TextHeading(context),
            children: [
              TextSpan(text: section.title),
              if (section.subtitle != null)
                TextSpan(
                  text: ' ${section.subtitle}',
                  style: AppTextStyle.medium12TextBody(context),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
