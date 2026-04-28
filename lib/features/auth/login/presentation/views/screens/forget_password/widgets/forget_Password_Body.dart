import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/widgets/custom_Phone%20Field.dart';
import 'package:dana/core/widgets/custom_elevetedButton.dart';
import 'package:dana/features/auth/login/presentation/views/screens/forget_password/widgets/forget_Password_Image.dart';
import 'package:dana/features/auth/login/presentation/views/screens/forget_password/widgets/forget_Password_Texts.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ForgetPasswordBody extends StatelessWidget {
  final TextEditingController phoneController;
  final VoidCallback onNextPressed;
  final VoidCallback onPhoneFieldTap;
  final bool isButtonEnabled;
  final bool isLoading;

  const ForgetPasswordBody({
    super.key,
    required this.phoneController,
    required this.onNextPressed,
    required this.onPhoneFieldTap,
    required this.isButtonEnabled,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.w24),
      child: Column(
        children: [
          ForgetPasswordImage(),
          ForgetPasswordTexts(),
          SizedBox(height: AppSizes.h36),
          CustomPhoneField(controller: phoneController),
          SizedBox(height: AppSizes.h32),
          CustomElevatedButton(
            text: AppLocalizations.of(context)!.nextButton,
            icon: Icons.arrow_forward_ios,
            onTap: isButtonEnabled ? onNextPressed : null,
            isDisabled: !isButtonEnabled,
          ),
          SizedBox(height: AppSizes.h24),
        ],
      ),
    );
  }
}
