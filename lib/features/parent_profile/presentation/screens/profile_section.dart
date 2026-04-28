import 'dart:io';

import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/widgets/custom_text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/parent_profile/presentation/widgets/profile_quick_access.dart';
import 'package:dana/features/parent_profile/data/models/child_model.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dana/features/parent_profile/presentation/bottom_sheets/add_child_bottom_sheet.dart';
import 'package:dana/features/parent_profile/presentation/bottom_sheets/change_language_bottom_sheet.dart';
import 'package:dana/features/parent_profile/presentation/bottom_sheets/change_theme_bottom_sheet.dart';
import 'package:dana/features/parent_profile/presentation/bottom_sheets/log_out_bottom_sheet.dart';
import 'package:dana/features/parent_profile/presentation/bottom_sheets/settings_bottom_sheet.dart';
import 'package:dana/features/parent_profile/presentation/widgets/add_child_card.dart';
import 'package:dana/features/parent_profile/presentation/widgets/child_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/parent_profile_cubit.dart';
import '../cubit/parent_profile_state.dart';
import '../../data/models/parent_profile_model.dart';

class ProfileSection extends StatefulWidget {
  static const String routeName = 'ProfileSection';

  const ProfileSection({super.key, required this.cubit});

  final ParentProfileCubit cubit;

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  int? selectedIndex = 1;

  Future<void> _pickParentProfilePhoto(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 88,
    );
    if (file == null || !context.mounted) return;
    final err = await context.read<ParentProfileCubit>().updateProfilePhoto(
          File(file.path),
        );
    if (!context.mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err == 'noProfile'
                ? context.l10n.parentPhotoNoProfile
                : err,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  ChildModel _mapApiChildToUi(ParentChildModel apiChild) {
    final birthDate = apiChild.birthDate;
    int years = 0, months = 0;
    if (birthDate != null) {
      final now = DateTime.now();
      int y = now.year - birthDate.year;
      int m = now.month - birthDate.month;
      if (now.day < birthDate.day) m -= 1;
      if (m < 0) {
        y -= 1;
        m += 12;
      }
      years = y < 0 ? 0 : y;
      months = m < 0 ? 0 : m;
    }
    final genderStr = apiChild.gender.toLowerCase();
    final gender = genderStr == 'female' ? 2 : 1;
    return ChildModel(
      id: apiChild.id,
      name: apiChild.childName,
      years: years,
      months: months,
      gender: gender,
      birthDate: apiChild.birthDate,
      profileImageUrl: apiChild.profileImageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<ParentProfileCubit, ParentProfileState>(
        listenWhen: (prev, next) =>
            next is ParentProfileError &&
            (prev is! ParentProfileError || prev.message != next.message),
        listener: (context, state) {
          if (state is ParentProfileError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final loaded = state is ParentProfileLoaded ? state.profile : null;
          final children = loaded == null
              ? <ChildModel>[]
              : loaded.children.map(_mapApiChildToUi).toList();

          final parentName = loaded?.parentName ?? '';
          final phone = loaded?.phone ?? '';
          final img = loaded?.profileImageUrl;

          return Padding(
            padding: EdgeInsets.only(top: 34.5.h, right: 24.w, left: 24.w),
            child: ListView(
              children: [
                CustomFrame(
                  hPadding: 12.w,
                  radius: AppRadius.radius_sm,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 36.r,
                                backgroundImage:
                                    (img != null &&
                                        img.isNotEmpty &&
                                        img.startsWith('http'))
                                    ? NetworkImage(img)
                                    : const AssetImage(
                                        'assets/Images/parent_photo.png',
                                      ),
                              ),
                              if (loaded != null)
                                Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: Material(
                                    color: isDark
                                        ? AppColors.primary_600_dark
                                        : AppColors.primary_600_light,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () => _pickParentProfilePhoto(
                                        context,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(6.r),
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          size: 18.r,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          if (state is ParentProfileLoading &&
                              loaded == null) ...[
                            SizedBox(
                              height: 20.h,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ] else if (state is ParentProfileError &&
                              loaded == null) ...[
                            TextButton(
                              onPressed: () =>
                                  context.read<ParentProfileCubit>().loadMe(),
                              child: Text(
                                'إعادة المحاولة',
                                style: AppTextStyle.medium12TextBody(context),
                              ),
                            ),
                          ] else ...[
                            Text(
                              parentName.isNotEmpty ? parentName : '—',
                              style: AppTextStyle.semibold16TextHeading(
                                context,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              phone.isNotEmpty ? phone : '—',
                              style: AppTextStyle.medium12TextBody(context),
                            ),
                          ],
                        ],
                      ),
                      Divider(
                        thickness: 0,
                        color: isDark
                            ? AppColors.border_card_default_dark
                            : AppColors.border_card_default_light,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.children,
                            style: AppTextStyle.medium16TextBody(context),
                          ),
                          SizedBox(height: 4.h),
                          SizedBox(
                            height: 140.w,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: children.length + 1,
                              itemBuilder: (context, index) {
                                if (index == children.length) {
                                  return AddChildCard(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: isDark
                                            ? AppColors.bg_surface_default_dark
                                            : AppColors
                                                  .bg_surface_default_light,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20.r),
                                          ),
                                        ),
                                        builder: (_) => AddChildBottomSheet(
                                          onAddChild: (child) async {
                                            final gender = child.gender == 1
                                                ? 'male'
                                                : 'female';
                                            final birth = child.birthDate;
                                            if (birth == null) {
                                              return 'Missing birth date';
                                            }
                                            return context
                                                .read<ParentProfileCubit>()
                                                .addChild(
                                                  childName: child.name,
                                                  gender: gender,
                                                  birthDate: birth,
                                                );
                                          },
                                          selectedIndex: selectedIndex,
                                        ),
                                      );
                                    },
                                  );
                                }

                                return Padding(
                                  padding: EdgeInsetsDirectional.only(end: 4.w),
                                  child: ChildCard(child: children[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.quickAccess,
                        style: AppTextStyle.medium16TextHeading(context),
                      ),
                      SizedBox(height: 12.h),
                      ProfileQuickAccess(isDark: isDark),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.settings,
                      style: AppTextStyle.medium16TextHeading(context),
                    ),
                    SizedBox(height: 12.h),
                    CustomTextFrame(
                      text: context.l10n.settings,
                      width: double.infinity,
                      bottomMargin: 8.h,
                      preIconSrc: 'assets/Icons/profile/settings_icon.svg',
                      sufIconSrc: 'assets/Icons/profile/arrow_icon.svg',
                      onTap: () {
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
                          builder: (_) => SettingsBottomSheet(
                            cubit: context.read<ParentProfileCubit>(),
                          ),
                        );
                      },
                    ),
                    CustomTextFrame(
                      text: context.l10n.changeLanguage,
                      sufText: context.l10n.arabic,
                      width: double.infinity,
                      bottomMargin: 8.h,
                      preIconSrc: 'assets/Icons/profile/language_icon.svg',
                      sufIconSrc: 'assets/Icons/profile/arrow_icon.svg',
                      onTap: () {
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
                          builder: (_) => const ChangeLanguageBottomSheet(),
                        );
                      },
                    ),
                    CustomTextFrame(
                      text: context.l10n.theme,
                      sufText: context.l10n.light,
                      width: double.infinity,
                      bottomMargin: 8.h,
                      preIconSrc: 'assets/Icons/profile/theme_icon.svg',
                      sufIconSrc: 'assets/Icons/profile/arrow_icon.svg',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r),
                            ),
                          ),
                          builder: (ctx) {
                            final themeProvider = ctx.watch<AppThemeProvider>();
                            final sheetDark =
                                themeProvider.appTheme == ThemeMode.dark ||
                                (themeProvider.appTheme == ThemeMode.system &&
                                    MediaQuery.of(ctx).platformBrightness ==
                                        Brightness.dark);

                            return Container(
                              decoration: BoxDecoration(
                                color: sheetDark
                                    ? AppColors.bg_surface_default_dark
                                    : AppColors.bg_surface_default_light,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r),
                                ),
                              ),
                              child: const ChangeThemeBottomSheet(),
                            );
                          },
                        );
                      },
                    ),
                    CustomTextFrame(
                      text: context.l10n.techSupport,
                      width: double.infinity,
                      bottomMargin: 8.h,
                      preIconSrc: 'assets/Icons/profile/support_icon.svg',
                      sufIconSrc: 'assets/Icons/profile/arrow_icon.svg',
                    ),
                    CustomTextFrame(
                      text: context.l10n.logout,
                      textStyle: AppTextStyle.medium16ErrorDefault(context),
                      bottomMargin: 60.h,
                      width: double.infinity,
                      preIconSrc: 'assets/Icons/profile/logOut_icon.svg',
                      onTap: () {
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
                          builder: (_) => const LogOutBottomSheet(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
