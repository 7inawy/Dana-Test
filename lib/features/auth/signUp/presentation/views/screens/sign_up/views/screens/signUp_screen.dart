import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/widgets/otp_bottom_sheet.dart';
import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/Custom_indicator.dart';
import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_state.dart';
import 'package:dana/features/auth/login/presentation/cubit/google_auth_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/google_auth_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../../../providers/app_theme_provider.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/core/errors/error_mapper.dart';
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
  late final GoogleAuthCubit _googleCubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<SignUpCubit>();
    _googleCubit = sl<GoogleAuthCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.close();
    _googleCubit.close();
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

  Future<void> _handleBack() async {
    if (_currentIndex > 0) {
      await _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    if (!mounted) return;
    await Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _googleCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SignUpCubit, SignUpState>(
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
            _controller.jumpToPage(3);
            setState(() => _currentIndex = 3);
          } else if (state is SignUpPasswordCreated) {
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            final msg = state.message;
            final lower = msg.toLowerCase();
            final alreadyExists =
                lower.contains('account already exists') ||
                lower.contains('already exists') ||
                lower.contains('already registered') ||
                msg.contains('الحساب موجود') ||
                msg.contains('موجود بالفعل') ||
                msg.contains('مسجل') ||
                msg.contains('مسجل بالفعل');

            if (alreadyExists && context.mounted) {
              await showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(context.l10n.accountAlreadyExistsTitle),
                  content: Text(msg),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(context.l10n.editInfo),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                      child: Text(context.l10n.login),
                    ),
                  ],
                ),
              );
              return;
            }

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ErrorMapper.localizeMessage(context, msg)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
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
                    SnackBar(
                      content: Text(context.l10n.couldNotOpenBrowser),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.continueGoogleInBrowser),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is GoogleAuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ErrorMapper.localizeMessage(context, state.message),
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: isDark
              ? AppColors.bg_surface_default_dark
              : AppColors.bg_surface_default_light,
          appBar: AppBar(
            backgroundColor: isDark
                ? AppColors.bg_card_default_dark
                : AppColors.bg_card_default_light,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              context.l10n.googleSignUpTitle,
              style: AppTextStyle.medium16TextHeading(context),
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: AppSizes.w24),
                child: CustomAppBarButton(onTap: _handleBack),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(AppSizes.h24),
              child: Padding(
                padding: EdgeInsets.only(bottom: AppSizes.h12),
                child: CustomIndicatorRow(
                  currentIndex: _currentIndex,
                  itemCount: 4,
                  height: AppSizes.h2,
                  activeWidth: 70,
                  inactiveWidth: 70,
                  spacing: 6,
                ),
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
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
