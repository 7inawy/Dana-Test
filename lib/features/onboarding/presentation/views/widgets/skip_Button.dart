import 'package:flutter/material.dart';

import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';

class SkipButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return TextButton(
      onPressed: () =>
          Navigator.pushReplacementNamed(context, AppRoutes.signup),
      child: Text(locale.skip, style: AppTextStyle.medium12TextBody(context)),
    );
  }
}
