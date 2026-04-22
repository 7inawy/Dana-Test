import 'package:dana/features/videos/presentation/views/widgets/video_Card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../data/model/video_Model.dart';
import 'no_Results_Widget.dart';

class SearchResults extends StatelessWidget {
  final List<VideoModel> results;

  const SearchResults({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    if (results.isEmpty) {
      return const NoResultsWidget();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            l10n.searchResults,
            style: AppTextStyle.medium16TextHeading(context),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 192 / 230,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) => VideoCard(
                video: results[index],
                imageWidth: 192.w,
                relatedVideos: results
                    .where((v) => v.title != results[index].title)
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
