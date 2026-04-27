import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_in_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_in_state.dart';
import 'package:dana/features/auth/login/presentation/cubit/google_auth_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/google_auth_state.dart';
import 'package:dana/features/auth/login/presentation/views/screens/login/widgets/login_actions.dart';
import 'package:dana/features/auth/login/presentation/views/screens/login/widgets/login_forgot_password.dart';
import 'package:dana/features/auth/login/presentation/views/screens/login/widgets/login_password_field.dart';
import 'package:dana/features/auth/login/presentation/views/screens/login/widgets/login_phone_field.dart';
import 'package:dana/core/widgets/otp_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignInCubit, SignInState>(
          listener: (context, state) async {
            if (state is SignInOtpSent) {
              OtpBottomSheet.show(
                context,
                state.phone,
                onVerified: (pin) async {
                  await context.read<SignInCubit>().verifySignIn(otp: pin);
                },
              );
            } else if (state is SignInSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              await sl<AuthSession>().setToken(state.user.token);
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else if (state is SignInFailure) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        BlocListener<GoogleAuthCubit, GoogleAuthState>(
          listener: (context, state) async {
            if (state is GoogleAuthLaunchUrl) {
              final ok = await launchUrl(
                Uri.parse(state.url),
                mode: LaunchMode.externalApplication,
              );
              if (!context.mounted) return;
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open browser'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pushNamed(context, AppRoutes.googleRequestId);
            } else if (state is GoogleAuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.h32),
            CustomScreenHeader(
              title: context.l10n.welcomeBackTitle,
              subtitle: context.l10n.loginDesc,
            ),
            SizedBox(height: AppSizes.h32),
            const LoginPhoneField(),
            const LoginPasswordField(),
            const LoginForgotPassword(),
            SizedBox(height: AppSizes.h82),
            const LoginActions(),
            SizedBox(height: AppSizes.h24),
          ],
        ),
      ),
    );
  }
}
