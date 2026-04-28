import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../../core/utils/app_raduis.dart';
import '../../../../../../../../core/widgets/otp_bottom_sheet.dart';
import '../../../../../../../../providers/app_theme_provider.dart';
import '../widgets/forget_Password_Body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/di/injection_container.dart';
import '../../../../cubit/reset_password_cubit.dart';
import '../../../../cubit/reset_password_state.dart';
import '../../new_password/screens/new_password_screen.dart';

class ForgetPasswordDialog extends StatefulWidget {
  static const String routeName = 'ForgetPasswordDialog';

  const ForgetPasswordDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (_) => BlocProvider(
        create: (_) => sl<ResetPasswordCubit>(),
        child: const ForgetPasswordDialog(),
      ),
    );
  }

  @override
  State<ForgetPasswordDialog> createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ForgetPasswordDialog> {
  final TextEditingController _phoneController = TextEditingController();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() {
      final hasText = _phoneController.text.trim().isNotEmpty;

      if (hasText != _isButtonEnabled) {
        setState(() {
          _isButtonEnabled = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  // void _onNextPressed() {
  //   final nav = Navigator.of(context);

  //   Navigator.pop(context);

  //   Future.delayed(Duration.zero, () {
  //     OtpBottomSheet.show(
  //       nav.context,
  //       _phoneController.text,
  //       onVerified: () {
  //         nav.pushNamed(NewPasswordScreen.routeName);
  //       },
  //     );
  //   });
  // }

  void _onNextPressed() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    context.read<ResetPasswordCubit>().sendOtp(phone: phone);
  }

  void _expandSheet() {
    _sheetController.animateTo(
      0.95,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordOtpSent) {
          final phone = state.phone;
          // Do not pop this sheet first: OTP runs on top while this widget (and
          // [ResetPasswordCubit]) stay mounted so [onVerified] can use [context].
          OtpBottomSheet.show(
            context,
            phone,
            onVerified: (pin) {
              context.read<ResetPasswordCubit>().verifyOtp(
                    phone: phone,
                    otp: pin,
                  );
            },
          );
        } else if (state is ResetPasswordOtpVerified) {
          final nav = Navigator.of(context, rootNavigator: true);
          if (nav.canPop()) {
            nav.pop();
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (nav.context.mounted) {
              NewPasswordScreen.show(
                nav.context,
                phone: state.phone,
                token: state.token,
              );
            }
          });
        } else if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          snap: true,
          snapSizes: const [0.5, 0.95],
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.bg_surface_default_dark
                    : AppColors.bg_surface_default_light,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.radius_lg),
                  topRight: Radius.circular(AppRadius.radius_lg),
                ),
              ),
              child: Column(
                children: [
                  HomeIndicator(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: ForgetPasswordBody(
                          phoneController: _phoneController,
                          isLoading: state is ResetPasswordLoading,
                          onNextPressed: _onNextPressed,
                          onPhoneFieldTap: _expandSheet,
                          isButtonEnabled: _isButtonEnabled,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
