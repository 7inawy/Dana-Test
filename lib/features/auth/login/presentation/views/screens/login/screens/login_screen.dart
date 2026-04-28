import 'package:dana/features/auth/login/presentation/views/screens/login/widgets/login_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../core/di/injection_container.dart';
import '../../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../../providers/app_theme_provider.dart';
import '../../../../cubit/google_auth_cubit.dart';
import '../../../../cubit/sign_in_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = 'LoginScreen';

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      body: Padding(
        padding: EdgeInsets.only(top: 34.5.h, right: 24.w, left: 24.w),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<SignInCubit>()),
            BlocProvider(create: (_) => sl<GoogleAuthCubit>()),
          ],
          child: const LoginBody(),
        ),
      ),
    );
  }
}
