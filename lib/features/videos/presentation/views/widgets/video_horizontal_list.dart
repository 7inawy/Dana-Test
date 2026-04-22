import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model/video_Model.dart';
import 'video_card.dart';

class VideoHorizontalList extends StatelessWidget {
  final List<VideoModel> videos;

  const VideoHorizontalList({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return SizedBox(
      height: 240.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: isRtl,
        itemCount: videos.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) => VideoCard(
          video: videos[index],
          relatedVideos: videos
              .where((v) => v.title != videos[index].title)
              .toList(),
        ),
      ),
    );
  }
}
