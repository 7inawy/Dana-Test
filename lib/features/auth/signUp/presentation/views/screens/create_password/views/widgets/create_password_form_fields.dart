import 'package:dana/core/widgets/password_field.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';

class CreatePasswordFormFields extends StatelessWidget {
  const CreatePasswordFormFields({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.passwordLabel,
          style: AppTextStyle.medium12TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        PasswordField(
          text: context.l10n.passwordHint,
          controller: passwordController,
        ),
        SizedBox(height: AppSizes.h16),
        Text(
          context.l10n.confirmPasswordLabel,
          style: AppTextStyle.medium12TextHeading(context),
        ),
        SizedBox(height: AppSizes.h8),
        PasswordField(
          text: context.l10n.confirmPasswordHint,
          controller: confirmPasswordController,
        ),
      ],
    );
  }
}
