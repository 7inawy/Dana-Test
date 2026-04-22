import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/video_Model.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoModel video;

  const VideoPlayerWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    final iconColor = isDark
        ? AppColors.icon_onLight_dark
        : AppColors.icon_onLight_light;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.radius_lg),
          child:
              (video.imageUrl.startsWith('http://') ||
                  video.imageUrl.startsWith('https://'))
              ? Image.network(
                  video.imageUrl,
                  width: 392.w,
                  height: 256.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                )
              : Image.asset(
                  video.imageUrl,
                  width: 392.w,
                  height: 256.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.bg_card_default_dark
                  : AppColors.bg_card_default_light,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.only(
              top: 16.h,
              left: 16.w,
              right: 16.w,
              bottom: 8.h,
            ),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '12:32 / ${video.duration}',
                  style: AppTextStyle.medium12TextBody(context),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.replay_10, color: iconColor, size: 24.w),

                    SizedBox(width: 8.w),
                    Icon(Icons.pause, color: iconColor, size: 24.w),
                    SizedBox(width: 8.w),
                    Icon(Icons.forward_10, color: iconColor, size: 24.w),
                  ],
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 44.h,
          left: 0,
          right: 0,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
              trackHeight: 2,
              trackShape: const RectangularSliderTrackShape(),
              activeTrackColor: isDark
                  ? AppColors.primary_default_dark
                  : AppColors.primary_default_light,
              inactiveTrackColor: isDark
                  ? AppColors.primary_default_dark.withAlpha(77)
                  : AppColors.primary_default_light.withAlpha(77),
              thumbColor: isDark
                  ? AppColors.primary_default_dark
                  : AppColors.primary_default_light,
            ),
            child: Slider(value: 0.6, onChanged: (_) {}),
          ),
        ),
      ],
    );
  }
}
