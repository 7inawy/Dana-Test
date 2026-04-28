import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/widgets/custom_elevetedButton.dart';

import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/sign_in_cubit.dart';
import '../../../../cubit/google_auth_cubit.dart';
import '../../../../../../signUp/presentation/views/screens/Personal_Information/views/widgets/custom_alreadyHaveAccount.dart';
import '../../../../../../signUp/presentation/views/screens/Personal_Information/views/widgets/custom_text_rich.dart';
import '../../../../../../signUp/presentation/views/screens/Personal_Information/views/widgets/cutom_google_signUp.dart';

class LoginActions extends StatelessWidget {
  const LoginActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          text: AppLocalizations.of(context)!.loginButton,
          onTap: () {
            // Trigger the real login flow:
            // 1) POST /v1/parent/pre-signIn (backend sends OTP to email)
            // 2) Show OTP bottom sheet (handled by `LoginBody` listener)
            // 3) Verify OTP via /v1/parent/verify-signIn and navigate to Home
            context.read<SignInCubit>().preSignIn();
          },
        ),
        SizedBox(height: AppSizes.h44),
        const CustomTextRich(),
        GoogleSignUpButton(
          onTap: () => context.read<GoogleAuthCubit>().start(),
        ),
        CustomAlreadyHaveAccount(
          textOne: AppLocalizations.of(context)!.noAccount,
          textTwo: AppLocalizations.of(context)!.createAccount,
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.signup);
          },
        ),
      ],
    );
  }
}
