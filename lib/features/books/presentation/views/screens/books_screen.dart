import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../../videos/presentation/views/screens/search_Screen.dart';
import '../../../../videos/presentation/views/widgets/videos_TabBar.dart';
import '../../../data/model/book_Model.dart';
import '../../cubit/textbooks_cubit.dart';
import '../../cubit/textbooks_state.dart';
import '../widgets/books_horizontal_list.dart';
import '../widgets/books_section_header.dart';
import '../widgets/books_vertical_list.dart';
import 'all_Books_Screen.dart';

class BooksScreen extends StatefulWidget {
  static const String routeName = 'BooksScreen';
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late String _activeTab;
  bool _initialized = false;
  late final TextBooksCubit _textBooksCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _activeTab = AppLocalizations.of(context)!.books;
  }

  @override
  void initState() {
    super.initState();
    _textBooksCubit = sl<TextBooksCubit>()..load();
  }

  @override
  void dispose() {
    _textBooksCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _textBooksCubit,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.bg_surface_default_dark
            : AppColors.bg_surface_default_light,
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
                      builder: (_) => BlocProvider.value(
                        value: _textBooksCubit,
                        child: SearchScreen(searchType: SearchType.books),
                      ),
                    ).whenComplete(() {
                      _textBooksCubit.load();
                    });
                  },
                ),
                Text(
                  l10n.books,
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
                Expanded(
                  child: BlocBuilder<TextBooksCubit, TextBooksState>(
                    builder: (context, state) {
                      if (state is TextBooksLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is TextBooksError) {
                        return Center(child: Text(state.message));
                      }
                      final books = state is TextBooksLoaded
                          ? state.books
                          : <BookModel>[];
                      final featured = books.take(4).toList();
                      final guides = books.skip(4).toList();
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            BooksSectionHeader(
                              title: l10n.featuredBooks,
                              onViewAll: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AllBooksScreen(
                                    books: featured,
                                    sectionTitle: l10n.featuredBooks,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            BooksHorizontalList(books: featured),
                            SizedBox(height: 24.h),
                            BooksSectionHeader(
                              title: l10n.guideBooks,
                              onViewAll: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AllBooksScreen(
                                    books: guides,
                                    sectionTitle: l10n.guideBooks,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            BooksVerticalList(books: guides),
                            SizedBox(height: 24.h),
                          ],
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
    );
  }
}
