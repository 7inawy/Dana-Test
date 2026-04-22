import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/widgets/otp_bottom_sheet.dart';
import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../providers/app_theme_provider.dart';
import '../widgets/sign_up_page_view.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'SignUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  late final SignUpCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<SignUpCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.close();
    super.dispose();
  }

  void _goToNextPage() {
    final ok = switch (_currentIndex) {
      0 => _cubit.onStep1Next(),
      1 => _cubit.onStep2Next(),
      _ => true,
    };
    if (!ok) return;

    if (_currentIndex < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) async {
          if (state is SignUpOtpSent) {
            OtpBottomSheet.show(
              context,
              state.phone,
              onVerified: (pin) async {
                await context.read<SignUpCubit>().verifySignUp(otp: pin);
              },
            );
          } else if (state is SignUpVerified) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            await sl<AuthSession>().setToken(state.token);
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            final msg = state.message;
            final lower = msg.toLowerCase();
            final alreadyExists =
                lower.contains('already') ||
                lower.contains('exist') ||
                msg.contains('موجود') ||
                msg.contains('مسجل');

            if (alreadyExists && context.mounted) {
              await showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Account already exists'),
                  content: Text(msg),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Edit info'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              );
              return;
            }

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: isDark
              ? AppColors.bg_surface_default_dark
              : AppColors.bg_surface_default_light,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: AppSizes.h24),
                Expanded(
                  child: SignUpPageView(
                    controller: _controller,
                    onPageChanged: _onPageChanged,
                    onNext: _goToNextPage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
