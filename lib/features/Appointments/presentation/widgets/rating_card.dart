import 'package:dana/core/widgets/custom_frame.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RateCard extends StatelessWidget {
  final Function(double rating) onRatingChanged;

  const RateCard({super.key, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return CustomFrame(
      vPadding: 12.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.rate,
            style: AppTextStyle.medium16TextHeading(context),
          ),
          RatingBar.builder(
            unratedColor: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            glow: false,
            initialRating: 0,
            minRating: 0.5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 28.r,
            itemPadding: EdgeInsets.only(top: 8.h, left: 16.w),
            itemBuilder: (context, _) => SvgPicture.asset(
              'assets/Icons/appointments/rating_star.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.warning_default_light,
                BlendMode.srcIn,
              ),
            ),
            onRatingUpdate: (rating) {
              onRatingChanged(rating);
            },
          ),
        ],
      ),
    );
  }
}
