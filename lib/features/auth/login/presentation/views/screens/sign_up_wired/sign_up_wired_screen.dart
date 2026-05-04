import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/widgets/otp_bottom_sheet.dart';
import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/core/widgets/custom_app_bar.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/core/errors/error_mapper.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dana/providers/app_theme_provider.dart';

/// A backend-wired Sign Up screen that uses `SignUpCubit`.
///
/// This intentionally replaces the older multi-screen Sign Up flow that
/// contained mock OTP navigation.
class SignUpWiredScreen extends StatelessWidget {
  static const String routeName = 'SignUpWiredScreen';

  const SignUpWiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignUpCubit>(),
      child: const _SignUpWiredView(),
    );
  }
}

class _SignUpWiredView extends StatefulWidget {
  const _SignUpWiredView();

  @override
  State<_SignUpWiredView> createState() => _SignUpWiredViewState();
}

class _SignUpWiredViewState extends State<_SignUpWiredView> {
  final _formKey = GlobalKey<FormState>();

  final _parentName = TextEditingController();
  final _government = TextEditingController();
  final _address = TextEditingController();
  final _childName = TextEditingController();
  final _childBirthDate = TextEditingController(); // YYYY-MM-DD
  String _childGender = 'male';
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _parentName.dispose();
    _government.dispose();
    _address.dispose();
    _childName.dispose();
    _childBirthDate.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _syncToCubit(SignUpCubit cubit) {
    cubit.updateParentName(_parentName.text);
    cubit.updateGovernment(_government.text);
    cubit.updateAddress(_address.text);
    cubit.updateChildName(_childName.text);
    cubit.updateChildBirthDate(_childBirthDate.text);
    cubit.updateChildGender(_childGender);
    cubit.updatePhone(_phone.text);
    cubit.updateEmail(_email.text);
    cubit.updatePassword(_password.text);
  }

  Future<void> _submit(SignUpCubit cubit) async {
    _syncToCubit(cubit);
    await cubit.preSignUp();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocListener<SignUpCubit, SignUpState>(
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
          if (!mounted) return;
          await sl<AuthSession>().setToken(state.token);
          if (!mounted) return;
          await context.read<SignUpCubit>().addPassword();
        } else if (state is SignUpPasswordCreated) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is SignUpFailure) {
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
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.googleSignUpTitle,
          isDark: isDark,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _parentName,
                  decoration: InputDecoration(
                    labelText: context.l10n.fullNameLabel,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? context.l10n.fieldRequired
                          : null,
                ),
                TextFormField(
                  controller: _government,
                  decoration: InputDecoration(
                    labelText: context.l10n.governorateLabel,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? context.l10n.fieldRequired
                          : null,
                ),
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(
                    labelText: context.l10n.addressLabel,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? context.l10n.fieldRequired
                          : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _childName,
                  decoration: InputDecoration(
                    labelText: context.l10n.childNameLabel,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? context.l10n.fieldRequired
                          : null,
                ),
                TextFormField(
                  controller: _childBirthDate,
                  decoration: InputDecoration(
                    labelText: context.l10n.birthDateLabel,
                    hintText: context.l10n.birthDateFormatYyyyMmDd,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? context.l10n.fieldRequired
                          : null,
                ),
                DropdownButtonFormField<String>(
                  initialValue: _childGender,
                  items: [
                    DropdownMenuItem(value: 'male', child: Text(context.l10n.boy)),
                    DropdownMenuItem(value: 'female', child: Text(context.l10n.girl)),
                  ],
                  onChanged: (v) => setState(() => _childGender = v ?? 'male'),
                  decoration: InputDecoration(
                    labelText: context.l10n.childGenderLabel,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(
                    labelText: context.l10n.phoneNumberLabel,
                    hintText: context.l10n.phoneNumberHint,
                    counterText: '',
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (v) {
                    final s = (v ?? '').replaceAll(RegExp(r'\D'), '');
                    if (s.isEmpty) return context.l10n.fieldRequired;
                    if (s.length < 10 || s.length > 11) {
                      return context.l10n.enterPhoneDigitsRange(10, 11);
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(labelText: context.l10n.email),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? context.l10n.fieldRequired
                          : null,
                ),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: context.l10n.passwordLabel,
                  ),
                  obscureText: true,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return context.l10n.fieldRequired;
                    if (s.length < 8) return context.l10n.passwordMinChars(8);
                    if (!RegExp(r'[A-Za-z]').hasMatch(s) ||
                        !RegExp(r'[0-9]').hasMatch(s)) {
                      return 'Password must contain letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<SignUpCubit, SignUpState>(
                  builder: (context, state) {
                    final loading = state is SignUpLoading;
                    return FilledButton(
                      onPressed: loading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              await _submit(context.read<SignUpCubit>());
                            },
                      child: Text(
                        loading
                            ? context.l10n.submitting
                            : context.l10n.createAccount,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                      child: Text(context.l10n.signIn),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
