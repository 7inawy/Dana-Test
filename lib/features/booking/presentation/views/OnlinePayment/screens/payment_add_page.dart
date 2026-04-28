import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/widgets/add_visa_bottom_sheet.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/widgets/confirmation_bottom_sheet.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/widgets/payment_details_section.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/widgets/visa_list_section.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PaymentAddScreen extends StatefulWidget {
  static const String routeName = 'PaymentAddScreen';

  const PaymentAddScreen({super.key});

  @override
  State<PaymentAddScreen> createState() => _PaymentAddScreenState();
}

class _PaymentAddScreenState extends State<PaymentAddScreen> {
  int? selectedVisa;
  List<Map<String, String>> visas = [];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final bool isButtonEnabled = selectedVisa != null;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: ListView(
                children: [
                  Image.asset('assets/Images/Master Card.png'),
                  SizedBox(height: 16.h),
                  VisaListSection(
                    visas: visas,
                    selectedVisa: selectedVisa,
                    isDark: isDark,
                    onSelectVisa: (i) => setState(() => selectedVisa = i),
                    onAddVisa: showAddVisaSheet,
                  ),
                  SizedBox(height: 24.h),
                  PaymentDetailsSection(isDark: isDark),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 83.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 192.w,
                    child: CustomButton(
                      color: isButtonEnabled
                          ? (isDark
                                ? AppColors.button_primary_default_dark
                                : AppColors.button_primary_default_light)
                          : (isDark
                                ? AppColors.bg_button_primary_disabled_dark
                                : AppColors.bg_button_primary_disabled_light),
                      text: 'إتمام الدفع',
                      textColor: isButtonEnabled
                          ? (isDark
                                ? AppColors.text_button_dark
                                : AppColors.text_button_light)
                          : (isDark
                                ? AppColors.text_button_disabled_dark
                                : AppColors.text_button_disabled_light),
                      onTap: () {
                        if (!isButtonEnabled) return;
                        showConfirmationSheet();
                      },
                    ),
                  ),
                  Text(
                    '250 ج',
                    style: AppTextStyle.semibold20TextDisplay(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAddVisaSheet() {
    final themeProvider = context.read<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) =>
          AddVisaBottomSheet(onSave: (card) => setState(() => visas.add(card))),
    );
  }

  void showConfirmationSheet() {
    final themeProvider = context.read<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? AppColors.bg_surface_default_dark
          : AppColors.bg_surface_default_light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => ConfirmationBottomSheet(isDark: isDark),
    );
  }
}
