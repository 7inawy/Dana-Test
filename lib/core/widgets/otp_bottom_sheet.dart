import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/core/widgets/otp_input_field.dart';
import 'package:dana/core/widgets/otp_resend_section.dart';
import 'dart:async';
import 'package:dana/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_theme_provider.dart';

class OtpBottomSheet extends StatefulWidget {
  final String phoneNumber;
  final ValueChanged<String>? onVerified;

  const OtpBottomSheet({super.key, required this.phoneNumber, this.onVerified});

  static void show(
    BuildContext context,
    String phoneNumber, {
    ValueChanged<String>? onVerified,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) =>
          OtpBottomSheet(phoneNumber: phoneNumber, onVerified: onVerified),
    );
  }

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _otpController = TextEditingController();
  int _remainingSeconds = 90;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // @override
  // void dispose() {
  //   _otpController.dispose();
  //   super.dispose();
  // }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // void _startTimer() {
  //   if (!mounted) return;

  //   setState(() {
  //     _remainingSeconds = 90;
  //     _canResend = false;
  //   });

  //   Future.delayed(const Duration(seconds: 1), _countdown);
  // }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 90;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  // void _countdown() {
  //   if (!mounted) return;

  //   if (_remainingSeconds > 0) {
  //     setState(() => _remainingSeconds--);
  //     Future.delayed(const Duration(seconds: 1), _countdown);
  //   } else {
  //     setState(() => _canResend = true);
  //   }
  // }

  // void _handleOtpComplete(String pin) {
  //   Navigator.pop(context);
  //   NewPasswordScreen.show(context);
  // }

  void _handleOtpComplete(String pin) {
    Navigator.pop(context);
    if (widget.onVerified != null) {
      widget.onVerified!(pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

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
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [HomeIndicator(), _buildBody()],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(AppSizes.w24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.h8),
          _buildTitle(),
          SizedBox(height: AppSizes.h8),
          _buildDescription(),
          SizedBox(height: AppSizes.h32),
          OtpInputField(
            controller: _otpController,
            onCompleted: _handleOtpComplete,
          ),
          SizedBox(height: AppSizes.h24),
          OtpResendSection(
            remainingSeconds: _remainingSeconds,
            canResend: _canResend,
            onResend: _startTimer,
          ),
          SizedBox(height: AppSizes.h24),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      AppLocalizations.of(context)!.verificationTitle,
      style: AppTextStyle.medium20TextDisplay(context),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(
            context,
          )!.verificationDescLine1(widget.phoneNumber),
          style: AppTextStyle.regular16TextBody(context),
          textAlign: TextAlign.center,
        ),
        Text(
          AppLocalizations.of(context)!.verificationDescLine2,
          style: AppTextStyle.regular16TextBody(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
