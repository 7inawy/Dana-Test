import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/videos/presentation/views/screens/search_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/video_Model.dart';
import '../../../../../core/di/injection_container.dart';
import '../../cubit/videos_cubit.dart';
import '../widgets/videos_TabBar.dart';
import '../widgets/view_all_widget.dart';

class ViewAllScreen extends StatefulWidget {
  static const String routeName = 'ViewAllScreen';
  final List<VideoModel> videos;
  final String sectionTitle;

  const ViewAllScreen({
    super.key,
    required this.videos,
    required this.sectionTitle,
  });

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
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
    _videosCubit = sl<VideosCubit>();
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
                  CustomAppBarButton(
                    iconSrc: 'assets/Icons/search_icon.svg',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) =>
                            SearchScreen(searchType: SearchType.videos),
                      );
                    },
                  ),
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
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  VideosTabBar(
                    activeTab: _activeTab,
                    onTabChanged: (t) => setState(() => _activeTab = t),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ViewAllWidget(
                        videos: widget.videos,
                        sectionTitle: widget.sectionTitle,
                      ),
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
