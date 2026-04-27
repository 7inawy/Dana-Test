import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/videos/presentation/views/screens/view_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/di/injection_container.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/video_Model.dart';
import '../../../data/repo/videos_repo.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/video_info_widget.dart';
import '../widgets/video_card.dart';

class VideoDetailsScreen extends StatefulWidget {
  static const String routeName = 'VideoDetailsScreen';
  final VideoModel video;
  final List<VideoModel> relatedVideos;

  const VideoDetailsScreen({
    super.key,
    required this.video,
    required this.relatedVideos,
  });

  @override
  State<VideoDetailsScreen> createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  late VideoModel _video;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _video = widget.video;
    _loadById();
  }

  Future<void> _loadById() async {
    try {
      final repo = sl<VideosRepo>();
      final fresh = await repo.getVideoById(widget.video.id);
      if (!mounted) return;
      setState(() {
        _video = fresh;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 56.w,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الفديوهات',
                style: AppTextStyle.medium16TextHeading(context),
              ),
              CustomAppBarButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                VideoPlayerWidget(video: _video),
                SizedBox(height: 16.h),
                if (_loading)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: const LinearProgressIndicator(),
                  ),
                if (_error != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      _error!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.regular12TextBody(context).copyWith(
                        color: isDark
                            ? AppColors.error_default_dark
                            : AppColors.error_default_light,
                      ),
                    ),
                  ),
                VideoInfoWidget(video: _video),
                SizedBox(height: 16.h),
                Row(
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.relatedVideos,
                      style: AppTextStyle.medium16TextHeading(context),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewAllScreen(
                              videos: widget.relatedVideos
                                  .where((v) => v.id != _video.id)
                                  .toList(),
                              sectionTitle: l10n.relatedVideos,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        l10n.viewAll,
                        style: AppTextStyle.regular12TextBody(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 280.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.relatedVideos.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        left: isRtl ? 8.w : 0,
                        right: isRtl ? 0 : 8.w,
                      ),
                      child: VideoCard(video: widget.relatedVideos[index]),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
