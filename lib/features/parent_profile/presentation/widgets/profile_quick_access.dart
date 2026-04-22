import 'package:dana/core/widgets/custom_text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/child_profile/child_profile_args.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import 'package:dana/features/parent_profile/presentation/cubit/parent_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileQuickAccess extends StatelessWidget {
  const ProfileQuickAccess({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // الحجوزات
                Expanded(
                  child: CustomTextFrame(
                    text: context.l10n.appointments,
                    preIconSrc: 'assets/Icons/profile/booking_icon.svg',
                    preIconBackgroundColor: isDark
                        ? AppColors.primary_50_dark
                        : AppColors.primary_50_light,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.appointments);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                // متابعة النمو
                Expanded(
                  child: CustomTextFrame(
                    text: context.l10n.growthTracking,
                    preIconSrc: 'assets/Icons/profile/groth_icon.svg',
                    preIconBackgroundColor: isDark
                        ? AppColors.primary_50_dark
                        : AppColors.primary_50_light,
                    onTap: () {
                      final s = context.read<ParentProfileCubit>().state;
                      if (s is! ParentProfileLoaded ||
                          s.profile.children.isEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.addChildDesc),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      final c = s.profile.children.first;
                      Navigator.of(context).pushNamed(
                        AppRoutes.childProfile,
                        arguments: ChildProfileArgs.fromParentChild(c),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // التطعيمات
                Expanded(
                  child: CustomTextFrame(
                    text: context.l10n.vaccinations,
                    preIconSrc: 'assets/Icons/profile/vaccin_icon.svg',
                    preIconBackgroundColor: isDark
                        ? AppColors.primary_50_dark
                        : AppColors.primary_50_light,
                    onTap: () {
                      final s = context.read<ParentProfileCubit>().state;
                      final id =
                          s is ParentProfileLoaded &&
                              s.profile.children.isNotEmpty
                          ? s.profile.children.first.id
                          : null;
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.vaccine, arguments: id);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                // محادثه ضنا
                Expanded(
                  child: CustomTextFrame(
                    text: context.l10n.danaChat,
                    preIconSrc: 'assets/Icons/profile/chat_icon.svg',
                    preIconBackgroundColor: isDark
                        ? AppColors.primary_50_dark
                        : AppColors.primary_50_light,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.aiChat);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
