import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/parent_phone_utils.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    this.controller,
    this.onNormalizedNumberChanged,
  });

  final TextEditingController? controller;

  /// Fired with [ParentPhoneUtils.normalizeForApi] whenever the intl field changes.
  final ValueChanged<String>? onNormalizedNumberChanged;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  String? _nationalValidator(PhoneNumber? pn) {
    if (pn == null) return null;
    final digits = pn.number.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;

    if (digits.length != 10) return 'Phone number must be exactly 10 digits';
    if (!digits.startsWith('1')) return 'Phone number must start with 1';
    return null;
  }

  TextEditingValue _enforceStartsWith1(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) return newValue.copyWith(text: '');

    // If user attempts to start with anything other than "1", reject the change.
    if (!digitsOnly.startsWith('1')) return oldValue;

    // Keep digits only; keep cursor at end to avoid odd jumps.
    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    // Phone numbers should stay LTR even in Arabic UI (RTL).
    // This keeps the flag/prefix on the left and avoids digit reordering.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: IntlPhoneField(
        controller: widget.controller,
        initialCountryCode: 'EG',

        textAlign: TextAlign.left,

        /// Package limits EG to 10; Egyptian numbers are often 11 with leading 0.
        disableLengthCheck: true,
        validator: _nationalValidator,
        onChanged: (PhoneNumber pn) {
          final nationalDigits = pn.number.replaceAll(RegExp(r'\D'), '');
          if (nationalDigits.isEmpty) {
            widget.onNormalizedNumberChanged?.call('');
            return;
          }
          widget.onNormalizedNumberChanged?.call(
            ParentPhoneUtils.normalizeForApi(pn.completeNumber),
          );
        },

        decoration: InputDecoration(
          filled: true,
          fillColor: isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
              width: 0.8.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
              width: 0.8.w,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 213, 44, 44),
              width: 0.8.w,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 213, 44, 44),
              width: 0.8.w,
            ),
          ),
          helperText: ' ',
          contentPadding: EdgeInsetsDirectional.only(top: 33.5.h, start: 108.w),
        ),
        style: AppTextStyle.medium16TextBody(context),
        flagsButtonMargin: EdgeInsets.symmetric(vertical: 9.h),
        flagsButtonPadding: EdgeInsetsGeometry.symmetric(vertical: 10.h),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction(_enforceStartsWith1),
          LengthLimitingTextInputFormatter(10),
        ],
        dropdownDecoration: BoxDecoration(
          color: isDark
              ? AppColors.border_card_default_dark
              : AppColors.border_card_default_light,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.r),
            bottomRight: Radius.circular(8.r),
            bottomLeft: Radius.circular(8.r),
            topLeft: Radius.circular(8.r),
          ),
        ),
        pickerDialogStyle: PickerDialogStyle(
          backgroundColor: isDark
              ? AppColors.bg_surface_default_dark
              : AppColors.bg_surface_default_light,
          searchFieldInputDecoration: InputDecoration(
            hintText: context.l10n.countrySearchHint,
            hintStyle: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: AppColors.text_body_light,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.border_card_default_dark
                    : AppColors.border_card_default_light,
              ),
            ),
            fillColor: AppColors.bg_surface_default_light,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.primary_default_dark
                    : AppColors.primary_default_light,
              ),
            ),
          ),
          searchFieldCursorColor: isDark
              ? AppColors.primary_default_dark
              : AppColors.primary_default_light,
          countryNameStyle: AppTextStyle.medium16TextBody(context),
          countryCodeStyle: AppTextStyle.medium16TextBody(context),
        ),
        dropdownTextStyle: AppTextStyle.medium16TextBody(context),
      ),
    );
  }
}
