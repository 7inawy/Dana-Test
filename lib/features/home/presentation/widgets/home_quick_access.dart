import 'package:dana/core/widgets/custom_text_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeQuickAccess extends StatelessWidget {
  const HomeQuickAccess({
    super.key,
    required this.context,
    required this.isDark,
  });

  final BuildContext context;
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
                Expanded(
                  child: CustomTextFrame(
                    text: context.l10n.checkYourChild,
                    preIconSrc: 'assets/Icons/home/check_icon.svg',
                    preIconBackgroundColor: isDark
                        ? AppColors.primary_50_dark
                        : AppColors.primary_50_light,
                    preIconColor: isDark
                        ? const Color.fromARGB(255, 63, 157, 168)
                        : AppColors.primary_default_light,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.examination);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomTextFrame(
                    text: context.l10n.videos,
                    preIconSrc: 'assets/Icons/home/videos_icon.svg',
                    preIconBackgroundColor: isDark
                        ? AppColors.primary_50_dark
                        : AppColors.primary_50_light,
                    preIconColor: isDark
                        ? const Color.fromARGB(255, 63, 157, 168)
                        : AppColors.primary_default_light,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.videos);
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
                Expanded(
                  child: CustomTextFrame(
                    text: context.l10n.booksAndArticles,
                    preIconSrc: 'assets/Icons/home/books_icon.svg',
                    preIconBackgroundColor: isDark
                        ? AppColors.primary_50_dark
                        : AppColors.primary_50_light,
                    preIconColor: isDark
                        ? const Color.fromARGB(255, 63, 157, 168)
                        : AppColors.primary_default_light,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.books);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomTextFrame(
                    text: context.l10n.vaccinations,
                    preIconSrc: 'assets/Icons/profile/vaccin_icon.svg',
                    preIconBackgroundColor: isDark
                        ? AppColors.primary_50_dark
                        : AppColors.primary_50_light,
                    preIconColor: isDark
                        ? const Color.fromARGB(255, 63, 157, 168)
                        : AppColors.primary_default_light,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.vaccine);
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
