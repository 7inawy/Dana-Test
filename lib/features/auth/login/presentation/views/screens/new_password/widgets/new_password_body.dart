import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/widgets/custom_elevetedButton.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/auth/login/presentation/cubit/change_password_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/change_password_state.dart';
import 'package:dana/features/auth/login/presentation/views/screens/new_password/widgets/new_password_fields.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPasswordBody extends StatefulWidget {
  const NewPasswordBody({super.key, required this.phone, required this.token});

  final String phone;
  final String token;

  @override
  State<NewPasswordBody> createState() => _NewPasswordBodyState();
}

class _NewPasswordBodyState extends State<NewPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        } else if (state is ChangePasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final loading = state is ChangePasswordLoading;
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HomeIndicator(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: AppSizes.h16),
                    CustomScreenHeader(
                      title: context.l10n.newPasswordTitle,
                      subtitle: context.l10n.newPasswordDesc,
                    ),
                    SizedBox(height: AppSizes.h36),
                    NewPasswordFields(
                      passwordController: _password,
                      confirmController: _confirm,
                    ),
                    SizedBox(height: AppSizes.h100),
                    CustomElevatedButton(
                      text: context.l10n.confirmPasswordButton,
                      isDisabled: loading,
                      onTap: () async {
                        if (loading) return;
                        if (!_formKey.currentState!.validate()) return;
                        await context.read<ChangePasswordCubit>().changePassword(
                              phone: widget.phone,
                              password: _password.text.trim(),
                              token: widget.token,
                            );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
