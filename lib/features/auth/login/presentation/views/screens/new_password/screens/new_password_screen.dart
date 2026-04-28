import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';

import 'package:dana/features/auth/login/presentation/views/screens/new_password/widgets/new_password_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/di/injection_container.dart';
import '../../../../cubit/change_password_cubit.dart';
import '../../../../../../../../providers/app_theme_provider.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key, required this.phone, required this.token});

  static String routeName = 'NewPasswordScreen';

  static void show(BuildContext context, {required String phone, required String token}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => BlocProvider(
        create: (_) => sl<ChangePasswordCubit>(),
        child: NewPasswordScreen(phone: phone, token: token),
      ),
    );
  }

  final String phone;
  final String token;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.bg_surface_default_dark
                  : AppColors.bg_surface_default_light,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.radius_lg),
                topRight: Radius.circular(AppRadius.radius_lg),
              ),
            ),
            child: NewPasswordBody(phone: phone, token: token),
          ),
        ),
      ),
    );
  }
}
