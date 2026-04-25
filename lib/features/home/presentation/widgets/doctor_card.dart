import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.imageSrc,
    required this.doctorName,
    this.rate = 0.0,
    this.width,
    this.specialtyText,
    this.onBookNow,
    this.onOpenChat,
  });

  final String imageSrc;
  final String doctorName;
  final double rate;
  final double? width;
  final String? specialtyText;
  final VoidCallback? onBookNow;
  final VoidCallback? onOpenChat;

  Widget _buildImage(BuildContext context) {
    final src = imageSrc.trim();
    final w = width;
    final h = 104.h;
    Widget core(Widget child) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radius_sm),
        child: SizedBox(width: w, height: h, child: child),
      );
    }

    if (src.startsWith('http')) {
      return core(
        Image.network(
          src,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Image.asset('assets/Images/home/doctor1.png', fit: BoxFit.cover),
        ),
      );
    }
    return core(Image.asset(src, fit: BoxFit.cover));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        borderRadius: BorderRadius.circular(AppRadius.radius_sm),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        child: Column(
          children: [
            _buildImage(context),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${context.l10n.dr} $doctorName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.medium12TextHeading(context),
                          ),
                        ),

                        Text(
                          '⭐$rate',
                          style: AppTextStyle.regular8TextBody(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      (specialtyText != null &&
                              specialtyText!.trim().isNotEmpty)
                          ? specialtyText!.trim()
                          : context.l10n.physiotherapist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.regular8TextBody(context),
                    ),
                    GestureDetector(
                      onTap:
                          onBookNow ??
                          () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.doctorTime);
                          },
                      child: Container(
                        margin: EdgeInsets.only(top: 12.h),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.button_primary_default_dark
                              : AppColors.button_primary_default_light,
                          borderRadius: BorderRadius.circular(
                            AppRadius.radius_full,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Center(
                            child: Text(
                              context.l10n.bookNow,
                              style: AppTextStyle.medium12TextButton(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
