import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/video_Model.dart';

import '../screens/video_details_screen.dart';
import '../../utils/video_playback_coordinator.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  final List<VideoModel> relatedVideos;
  final double? imageWidth;
  final bool replaceCurrent;

  const VideoCard({
    super.key,
    required this.video,
    this.relatedVideos = const [],
    this.imageWidth,
    this.replaceCurrent = false,
  });

  Widget _thumbnailPlaceholder(BuildContext context, {required double width}) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      width: width,
      height: 180.h,
      color: isDark
          ? AppColors.bg_card_default_dark
          : AppColors.bg_card_default_light,
      alignment: Alignment.center,
      child: Icon(
        Icons.play_circle_outline,
        size: 28.w,
        color: isDark
            ? AppColors.icon_onLight_dark
            : AppColors.icon_onLight_light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final width = imageWidth ?? 142.w;
    final cover = video.resolvedImageUrl.trim();
    final isNetworkCover =
        cover.startsWith('http://') || cover.startsWith('https://');
    final hasCover = cover.isNotEmpty;

    return GestureDetector(
      onTap: () {
        // Stop any currently playing video before navigating, because the
        // previous details route may still be alive in the navigation stack.
        VideoPlaybackCoordinator.pauseActive();

        final route = MaterialPageRoute(
          builder: (_) =>
              VideoDetailsScreen(video: video, relatedVideos: relatedVideos),
        );

        if (replaceCurrent) {
          Navigator.pushReplacement(context, route);
        } else {
          Navigator.push(context, route);
        }
      },
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment:
              isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.radius_md),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.border_card_default_dark
                        : AppColors.border_card_default_light,
                    width: AppRadius.stroke_bold,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.radius_md),
                child: hasCover
                    ? (isNetworkCover
                        ? Image.network(
                            cover,
                            width: width,
                            height: 180.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _thumbnailPlaceholder(context, width: width),
                          )
                        : Image.asset(
                            cover,
                            width: width,
                            height: 180.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _thumbnailPlaceholder(context, width: width),
                          ))
                    : _thumbnailPlaceholder(context, width: width),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: width,
              child: Text(
                video.titleForLocale(Localizations.localeOf(context)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: AppTextStyle.medium12TextHeading(context),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 10.w,
                  color: isDark
                      ? AppColors.icon_onLight_dark
                      : AppColors.icon_onLight_light,
                ),
                SizedBox(width: 2.w),
                Text(
                  video.duration,
                  style: AppTextStyle.regular8TextBody(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
