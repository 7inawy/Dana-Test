import 'package:dana/core/widgets/custom_app_bar.dart';
import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/videos/presentation/views/screens/search_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/video_Model.dart';
import '../../../../../core/di/injection_container.dart';
import '../../cubit/videos_cubit.dart';
import '../../cubit/videos_state.dart';
import '../widgets/section_Row.dart';
import '../widgets/videos_TabBar.dart';

class VideosScreen extends StatefulWidget {
  static const String routeName = 'VideosScreen';
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  late String _activeTab;
  bool _initialized = false;
  late final VideosCubit _videosCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _activeTab = AppLocalizations.of(context)!.videos;
  }

  @override
  void initState() {
    super.initState();
    _videosCubit = sl<VideosCubit>()..load();
  }

  @override
  void dispose() {
    _videosCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocProvider.value(
      value: _videosCubit,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: CustomAppBar(
            title: context.l10n.videos,
            isDark: isDark,
            trailing: CustomAppBarButton(
              iconSrc: 'assets/Icons/search_icon.svg',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => SearchScreen(searchType: SearchType.videos),
                );
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: AppSizes.h12),
                  VideosTabBar(
                    activeTab: _activeTab,
                    onTabChanged: (t) => setState(() => _activeTab = t),
                  ),
                  SizedBox(height: AppSizes.h12),
                  Expanded(
                    child: BlocBuilder<VideosCubit, VideosState>(
                      builder: (context, state) {
                        if (state is VideosLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is VideosError) {
                          return Center(child: Text(state.message));
                        }
                        final videos = state is VideosLoaded
                            ? state.videos
                            : context.read<VideosCubit>().cachedVideos;
                        final sections = [
                          VideoSection(
                            title: context.l10n.videos,
                            videos: videos,
                          ),
                        ];
                        return SingleChildScrollView(
                          child: Column(
                            children: sections
                                .map((section) => SectionRow(section: section))
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
