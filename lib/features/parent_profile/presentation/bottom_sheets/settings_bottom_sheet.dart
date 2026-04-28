import 'package:dana/core/widgets/custom_text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/auth/login/presentation/views/screens/forget_password/screens/forget_password_page.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/core/widgets/home_indicator.dart';
import 'package:dana/features/parent_profile/presentation/bottom_sheets/edit_profile_bottom_sheet.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key, required this.cubit});

  final ParentProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

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
              context.l10n.accountSettingsTitle,
              style: AppTextStyle.medium20TextDisplay(context),
            ),
            SizedBox(height: 8.h),
            Text(
              context.l10n.accountSettingsDesc,
              style: AppTextStyle.regular16TextBody(context),
            ),
            SizedBox(height: 24.h),
            // تغيير البيانات الشخصيه
            CustomTextFrame(
              text: context.l10n.editProfile,
              height: 64.h,
              width: double.infinity,
              bottomMargin: 12.h,
              preIconSrc: 'assets/Icons/profile/profile_icon.svg',
              sufIconSrc: 'assets/Icons/profile/arrow_icon.svg',
              preIconBackgroundColor: isDark
                  ? AppColors.primary_50_dark
                  : AppColors.primary_50_light,
              preIconColor: isDark
                  ? const Color.fromARGB(255, 63, 157, 168)
                  : AppColors.icon_onLight_light,
              onTap: () {
                final state = cubit.state;
                Navigator.pop(context);
                if (state is! ParentProfileLoaded) return;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: isDark
                      ? AppColors.bg_surface_default_dark
                      : AppColors.bg_surface_default_light,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  builder: (sheetCtx) => BlocProvider.value(
                    value: cubit,
                    child: EditProfileBottomSheet(initial: state.profile),
                  ),
                );
              },
            ),
            // كلمه السر
            CustomTextFrame(
              text: context.l10n.changePassword,
              height: 64.h,
              width: double.infinity,
              bottomMargin: 150.h,
              preIconSrc: 'assets/Icons/profile/password_icon.svg',
              sufIconSrc: 'assets/Icons/profile/arrow_icon.svg',
              preIconBackgroundColor: isDark
                  ? AppColors.primary_50_dark
                  : AppColors.primary_50_light,
              preIconColor: isDark
                  ? const Color.fromARGB(255, 63, 157, 168)
                  : AppColors.icon_onLight_light,
              onTap: () {
                Navigator.pop(context);
                ForgetPasswordDialog.show(context);
                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true,
                //   backgroundColor: isDark
                //       ? AppColors.bg_surface_default_dark
                //       : AppColors.bg_surface_default_light,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.vertical(
                //       top: Radius.circular(20.r),
                //     ),
                //   ),
                //   builder: (_) => ChangePasswordBottomSheet(),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
