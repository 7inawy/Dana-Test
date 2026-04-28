import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_state.dart';
import '../widgets/create_password_body.dart';

class CreatePasswordScreen extends StatefulWidget {
  static const String routeName = 'CreatePasswordScreen';
  final VoidCallback? onNext;

  const CreatePasswordScreen({super.key, required this.onNext});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppRadius.radius_xl),
        child: BlocBuilder<SignUpCubit, SignUpState>(
          buildWhen: (p, n) => n is SignUpLoading || p is SignUpLoading,
          builder: (context, state) {
            final loading = state is SignUpLoading;
            return CustomButton(
              onTap: () async {
                if (loading) return;
                if (passwordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.passwordsMismatch),
                    ),
                  );
                  return;
                }
                final cubit = context.read<SignUpCubit>();
                cubit.updatePassword(passwordController.text);
                await cubit.addPassword();
              },
              text: context.l10n.createAccount,
            );
          },
        ),
      ),
      body: SafeArea(
        child: CreatePasswordBody(
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
        ),
      ),
    );
  }
}
