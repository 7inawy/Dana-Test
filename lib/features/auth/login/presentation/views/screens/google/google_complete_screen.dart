import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_screen_header.dart';
import 'package:dana/core/widgets/custom_textForm.dart';
import 'package:dana/core/widgets/password_field.dart';
import 'package:dana/core/widgets/phone_field.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/core/errors/error_mapper.dart';
import 'package:dana/features/auth/login/data/datasources/auth_remote_data_source.dart';
import 'package:dana/features/auth/login/presentation/cubit/google_auth_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/google_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../providers/app_theme_provider.dart';
import 'google_complete_validators.dart';

class GoogleCompleteScreen extends StatefulWidget {
  static const String routeName = 'GoogleCompleteScreen';

  final String requestId;

  const GoogleCompleteScreen({super.key, required this.requestId});

  @override
  State<GoogleCompleteScreen> createState() => _GoogleCompleteScreenState();
}

class _ChildForm {
  final name = TextEditingController();
  final birthDate = TextEditingController(); // YYYY-MM-DD (API)
  String gender = 'male';

  void dispose() {
    name.dispose();
    birthDate.dispose();
  }
}

class _GoogleCompleteScreenState extends State<GoogleCompleteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phone = TextEditingController();
  String _normalizedPhone = '';
  final _password = TextEditingController();
  final _government = TextEditingController();
  final _address = TextEditingController();

  final List<_ChildForm> _children = [_ChildForm()];
  static const int _maxChildren = 5;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    _government.dispose();
    _address.dispose();
    for (final c in _children) {
      c.dispose();
    }
    super.dispose();
  }

  List<ChildData> _buildChildren() {
    return _children
        .map(
          (c) => ChildData(
            childName: c.name.text.trim(),
            gender: c.gender,
            birthDate: c.birthDate.text.trim(),
          ),
        )
        .toList();
  }

  Future<void> _pickChildBirthDate(_ChildForm c) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Localizations.localeOf(context),
    );
    if (picked == null) return;
    setState(() => c.birthDate.text = GoogleCompleteValidators.fmtYyyyMmDd(picked));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GoogleAuthCubit>(),
      child: BlocListener<GoogleAuthCubit, GoogleAuthState>(
        listener: (context, state) async {
          if (state is GoogleAuthSuccess) {
            await sl<AuthSession>().setToken(state.user.token);
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
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
        child: Scaffold(
          appBar: AppBar(title: Text(context.l10n.completeAccountTitle)),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Consumer<AppThemeProvider>(
                builder: (context, themeProvider, _) {
                  final isDark =
                      themeProvider.appTheme == ThemeMode.dark ||
                      (themeProvider.appTheme == ThemeMode.system &&
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark);
                  final cardColor = isDark
                      ? AppColors.bg_card_default_dark
                      : AppColors.bg_card_default_light;
                  final borderColor = isDark
                      ? AppColors.border_card_default_dark
                      : AppColors.border_card_default_light;

                  return ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w24,
                      vertical: AppSizes.h24,
                    ),
                    children: [
                      CustomScreenHeader(
                        title: context.l10n.completeAccountHeaderTitle,
                        subtitle: context.l10n.completeAccountHeaderSubtitle,
                      ),
                      SizedBox(height: AppSizes.h24),

                      Text(
                        context.l10n.phoneLabel,
                        style: AppTextStyle.medium12TextHeading(context),
                      ),
                      SizedBox(height: AppSizes.h8),
                      SizedBox(
                        height: 64.h,
                        child: PhoneField(
                          controller: _phone,
                          onNormalizedNumberChanged: (v) {
                            _normalizedPhone = v;
                          },
                        ),
                      ),
                      if (_normalizedPhone.trim().isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            context.l10n.phoneRequired,
                            style: AppTextStyle.semibold12ErrorDefault(context),
                          ),
                        ),

                      SizedBox(height: AppSizes.h16),
                      Text(
                        context.l10n.passwordLabel,
                        style: AppTextStyle.medium12TextHeading(context),
                      ),
                      SizedBox(height: AppSizes.h8),
                      PasswordField(
                        text: context.l10n.passwordRequirementsMin8,
                        controller: _password,
                        validator: (v) =>
                            GoogleCompleteValidators.validatePassword(context, v),
                      ),

                      SizedBox(height: AppSizes.h16),
                      CustomTextForm(
                        text: context.l10n.governorateLabel,
                        hintText: context.l10n.governorateHint,
                        controller: _government,
                        validator: (v) =>
                            GoogleCompleteValidators.validateGovernment(context, v),
                        keyboardType: TextInputType.name,
                      ),

                      SizedBox(height: AppSizes.h16),
                      CustomTextForm(
                        text: context.l10n.addressLabel,
                        hintText: context.l10n.addressHint,
                        controller: _address,
                        validator: (v) =>
                            GoogleCompleteValidators.validateAddress(context, v),
                        keyboardType: TextInputType.streetAddress,
                        maxLines: 2,
                      ),

                      SizedBox(height: AppSizes.h24),
                      Text(
                        context.l10n.children,
                        style: AppTextStyle.semibold16TextHeading(context),
                      ),
                      SizedBox(height: AppSizes.h8),

                      ..._children.asMap().entries.map((entry) {
                        final i = entry.key;
                        final c = entry.value;
                        return Container(
                          margin: EdgeInsets.only(bottom: AppSizes.h16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    context.l10n.childIndexLabel(i + 1),
                                    style: AppTextStyle.medium16TextHeading(
                                      context,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (_children.length > 1)
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          final removed =
                                              _children.removeAt(i);
                                          removed.dispose();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: isDark
                                            ? AppColors.error_default_dark
                                            : AppColors.error_default_light,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              CustomTextForm(
                                text: context.l10n.childNameLabel,
                                hintText: context.l10n.childNameHint,
                                controller: c.name,
                                validator: (v) =>
                                    GoogleCompleteValidators.validateChildName(
                                      context,
                                      v,
                                    ),
                                keyboardType: TextInputType.name,
                              ),
                              SizedBox(height: 12.h),
                              CustomTextForm(
                                text: context.l10n.birthDateLabel,
                                hintText: context.l10n.birthDateHint,
                                controller: c.birthDate,
                                validator: (v) =>
                                    GoogleCompleteValidators.validateBirthDate(
                                      context,
                                      v,
                                    ),
                                readOnly: true,
                                onTap: () => _pickChildBirthDate(c),
                                suffixIcon: const Icon(
                                  Icons.calendar_month_rounded,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              DropdownButtonFormField<String>(
                                initialValue: c.gender,
                                items: [
                                  DropdownMenuItem(
                                    value: 'male',
                                    child: Text(context.l10n.boy),
                                  ),
                                  DropdownMenuItem(
                                    value: 'female',
                                    child: Text(context.l10n.girl),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => c.gender = v ?? 'male'),
                                validator: (v) =>
                                    GoogleCompleteValidators.requiredText(
                                      context,
                                      v,
                                    ),
                                decoration: InputDecoration(
                                  labelText: context.l10n.genderLabel,
                                  filled: true,
                                  fillColor: cardColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: borderColor,
                                      width: 0.8.w,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? AppColors.primary_default_dark
                                          : AppColors.primary_default_light,
                                      width: 0.8.w,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        255,
                                        213,
                                        44,
                                        44,
                                      ),
                                      width: 0.8.w,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        255,
                                        213,
                                        44,
                                        44,
                                      ),
                                      width: 0.8.w,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      TextButton.icon(
                        onPressed: _children.length >= _maxChildren
                            ? null
                            : () => setState(() => _children.add(_ChildForm())),
                        icon: const Icon(Icons.add),
                        label: Text(
                          _children.length >= _maxChildren
                              ? context.l10n.maxChildrenReached(_maxChildren)
                              : context.l10n.addChild,
                          style: AppTextStyle.semibold12Primary(context),
                        ),
                      ),

                      SizedBox(height: AppSizes.h16),
                      BlocBuilder<GoogleAuthCubit, GoogleAuthState>(
                        builder: (context, state) {
                          final loading = state is GoogleAuthCompleteLoading;
                          return CustomButton(
                            text: loading
                                ? context.l10n.submitting
                                : context.l10n.complete,
                            isLoading: loading,
                            enabled: !loading,
                            onTap: () async {
                              final formOk =
                                  _formKey.currentState?.validate() ?? false;
                              final phoneOk = _normalizedPhone.trim().isNotEmpty;
                              if (!formOk || !phoneOk) {
                                setState(() {});
                                return;
                              }
                              await context.read<GoogleAuthCubit>().complete(
                                    requestId: widget.requestId,
                                    phone: _normalizedPhone,
                                    password: _password.text.trim(),
                                    government: _government.text.trim(),
                                    address: _address.text.trim(),
                                    children: _buildChildren(),
                                  );
                            },
                          );
                        },
                      ),
                      SizedBox(height: AppSizes.h16),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

