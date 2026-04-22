import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/video_Model.dart';

import '../screens/video_details_screen.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  final List<VideoModel> relatedVideos;
  final double? imageWidth;

  const VideoCard({
    super.key,
    required this.video,
    this.relatedVideos = const [],
    this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final width = imageWidth ?? 142.w;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                VideoDetailsScreen(video: video, relatedVideos: relatedVideos),
          ),
        );
      },
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
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
                child:
                    (video.imageUrl.startsWith('http://') ||
                        video.imageUrl.startsWith('https://'))
                    ? Image.network(
                        video.imageUrl,
                        width: width,
                        height: 180.h,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      )
                    : Image.asset(
                        video.imageUrl,
                        width: width,
                        height: 180.h,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: width,
              child: Text(
                video.title,
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
