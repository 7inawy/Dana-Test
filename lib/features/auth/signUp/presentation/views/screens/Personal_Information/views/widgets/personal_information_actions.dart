import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/widgets/custom_elevetedButton.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_alreadyHaveAccount.dart';
import 'custom_text_rich.dart';
import 'cutom_google_signUp.dart';
import '../../../../../../../login/presentation/cubit/google_auth_cubit.dart';

class PersonalInformationActions extends StatelessWidget {
  final VoidCallback? onNext;

  const PersonalInformationActions({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          onTap: onNext,
          text: AppLocalizations.of(context)!.next,
          icon: Icons.arrow_forward_ios,
        ),
        SizedBox(height: AppSizes.h44),
        const CustomTextRich(),
        GoogleSignUpButton(
          onTap: () => context.read<GoogleAuthCubit>().start(),
        ),
        CustomAlreadyHaveAccount(
          textOne: AppLocalizations.of(context)!.alreadyHaveAccount,
          textTwo: AppLocalizations.of(context)!.signIn,
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          },
        ),
      ],
    );
  }
}
