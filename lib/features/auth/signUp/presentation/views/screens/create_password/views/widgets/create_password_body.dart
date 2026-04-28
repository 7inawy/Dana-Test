import 'package:dana/core/widgets/Custom_indicator.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/l10n/app_localizations.dart';

import 'create_password_form_fields.dart';

class CreatePasswordBody extends StatelessWidget {
  const CreatePasswordBody({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppSizes.w24),
          child: CustomIndicatorRow(currentIndex: 3, itemCount: 4),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.h24),
                  CustomScreenHeader(
                    title: AppLocalizations.of(context)!.choosePasswordTitle,
                    subtitle: AppLocalizations.of(context)!.choosePasswordDesc,
                  ),
                  SizedBox(height: AppSizes.h32),
                  CreatePasswordFormFields(
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
                  SizedBox(height: AppSizes.h48),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
