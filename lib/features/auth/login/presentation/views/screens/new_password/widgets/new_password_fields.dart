import 'package:dana/core/widgets/password_field.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/l10n/app_localizations.dart';

class NewPasswordFields extends StatelessWidget {
  const NewPasswordFields({
    super.key,
    required this.passwordController,
    required this.confirmController,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.newPasswordLabel,
          style: AppTextStyle.medium12TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        PasswordField(
          text: AppLocalizations.of(context)!.newPasswordHint,
          controller: passwordController,
          validator: (v) {
            final s = (v ?? '').trim();
            if (s.isEmpty) return 'Required';
            if (s.length < 6) return 'Min 6 chars';
            return null;
          },
        ),
        SizedBox(height: AppSizes.h16),
        Text(
          AppLocalizations.of(context)!.confirmPasswordLabel,
          style: AppTextStyle.medium12TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        PasswordField(
          text: AppLocalizations.of(context)!.confirmPasswordHint,
          controller: confirmController,
          validator: (v) {
            final s = (v ?? '').trim();
            if (s.isEmpty) return 'Required';
            if (s != passwordController.text.trim()) {
              return AppLocalizations.of(context)!.passwordsMismatch;
            }
            return null;
          },
        ),
      ],
    );
  }
}
