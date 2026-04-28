import 'package:dana/core/widgets/custom_button.dart';
import 'package:dana/core/widgets/custom_text_field.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/child_profile/presentation/bottom_sheets/confirm_data_bottom_sheet.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/growth_cubit.dart';

/// Opens [UpdateDataBottomSheet] with [GrowthCubit] in scope (modal route safe).
Future<void> showUpdateMeasurementsBottomSheet(BuildContext hostContext) async {
  final growth = hostContext.read<GrowthCubit>();
  final themeProvider = hostContext.read<AppThemeProvider>();
  final isDark =
      themeProvider.appTheme == ThemeMode.dark ||
      (themeProvider.appTheme == ThemeMode.system &&
          MediaQuery.of(hostContext).platformBrightness == Brightness.dark);

  await showModalBottomSheet<void>(
    context: hostContext,
    isScrollControlled: true,
    backgroundColor: isDark
        ? AppColors.bg_surface_default_dark
        : AppColors.bg_surface_default_light,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (sheetContext) => BlocProvider.value(
      value: growth,
      child: UpdateDataBottomSheet(
        onSaved: () {
          if (!hostContext.mounted) return;
          showModalBottomSheet<void>(
            context: hostContext,
            isScrollControlled: true,
            backgroundColor: isDark
                ? AppColors.bg_surface_default_dark
                : AppColors.bg_surface_default_light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            builder: (_) => ConfirmDataBottomSheet(
              firstText: hostContext.l10n.growthCelebrationTitle,
              secondText: hostContext.l10n.growthSavedMessage,
            ),
          );
        },
        onDuplicateMonth: () {
          if (!hostContext.mounted) return;
          ScaffoldMessenger.of(hostContext).showSnackBar(
            SnackBar(
              content: Text(hostContext.l10n.growthDuplicateMonth),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    ),
  );
}

class UpdateDataBottomSheet extends StatefulWidget {
  const UpdateDataBottomSheet({super.key, this.onSaved, this.onDuplicateMonth});

  /// Called after a successful save and sheet dismiss, using the **host** screen context.
  final VoidCallback? onSaved;
  final VoidCallback? onDuplicateMonth;

  @override
  State<UpdateDataBottomSheet> createState() => _UpdateDataBottomSheetState();
}

class _UpdateDataBottomSheetState extends State<UpdateDataBottomSheet> {
  double? childWeight;
  double? childHeight;
  double? headCircumference;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final l10n = context.l10n;

    final bool isButtonEnabled =
        childWeight != null && childHeight != null && headCircumference != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: HomeIndicator()),
            SizedBox(height: 20.h),
            Text(
              l10n.updateDataTitle,
              style: AppTextStyle.medium20TextDisplay(context),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.updateDataDesc,
              style: AppTextStyle.regular16TextBody(context),
            ),
            SizedBox(height: 24.h),

            Text(l10n.weight, style: AppTextStyle.medium12TextBody(context)),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: l10n.exampleValue,
              suffixText: l10n.kg,
              onChange: (value) {
                setState(() {
                  childWeight = double.tryParse(value);
                });
              },
            ),

            SizedBox(height: 16.h),
            Text(l10n.height, style: AppTextStyle.medium12TextBody(context)),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: l10n.exampleValue,
              suffixText: l10n.cm,
              onChange: (value) {
                setState(() {
                  childHeight = double.tryParse(value);
                });
              },
            ),

            SizedBox(height: 16.h),
            Text(
              l10n.headCircumference,
              style: AppTextStyle.medium12TextBody(context),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: l10n.exampleValue,
              suffixText: l10n.cm,
              onChange: (value) {
                setState(() {
                  headCircumference = double.tryParse(value);
                });
              },
            ),

            SizedBox(height: 40.h),
            CustomButton(
              color: isButtonEnabled
                  ? (isDark
                        ? AppColors.button_primary_default_dark
                        : AppColors.button_primary_default_light)
                  : (isDark
                        ? AppColors.bg_button_primary_disabled_dark
                        : AppColors.bg_button_primary_disabled_light),
              text: context.l10n.saveNewMeasurements,
              borderColor: isDark
                  ? AppColors.bg_button_primary_disabled_dark
                  : AppColors.bg_button_primary_disabled_light,

              textStyle: isButtonEnabled
                  ? AppTextStyle.semibold16TextButton(context)
                  : AppTextStyle.semibold16TextButtonDisabled(context),
              onTap: isButtonEnabled
                  ? () async {
                      final err = await context.read<GrowthCubit>().submit(
                        height: childHeight!,
                        weight: childWeight!,
                        headCircumference: headCircumference!,
                      );
                      if (!context.mounted) return;
                      if (err == 'growthDuplicateMonth') {
                        Navigator.pop(context);
                        widget.onDuplicateMonth?.call();
                        return;
                      }
                      if (err == 'growthNotLoaded') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.growthNotLoaded),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      if (err != null) return;
                      Navigator.pop(context);
                      widget.onSaved?.call();
                    }
                  : () {},
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
