import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class ForgetPasswordTexts extends StatelessWidget {
  const ForgetPasswordTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.forgotPassword,
          style: AppTextStyle.medium20TextDisplay(context),
        ),
        SizedBox(height: AppSizes.h8),
        Text(
          AppLocalizations.of(context)!.forgotPasswordDesc,
          style: AppTextStyle.regular16TextBody(context),
        ),
      ],
    );
  }
}
