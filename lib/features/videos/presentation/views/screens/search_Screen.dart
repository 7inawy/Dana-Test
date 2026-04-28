import 'package:dana/core/widgets/home_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../../books/data/model/book_Model.dart';
import '../../../../books/presentation/views/screens/read_Book_Screen.dart';
import '../../../../books/presentation/views/widgets/book_card_vertical.dart';
import '../../../data/model/video_Model.dart';
import '../../cubit/videos_cubit.dart';
import '../../cubit/videos_state.dart';
import '../../../../books/presentation/cubit/textbooks_cubit.dart';
import '../../../../books/presentation/cubit/textbooks_state.dart';
import '../widgets/no_Results_Widget.dart';
import '../widgets/search_Bar_Widget.dart';
import '../widgets/search_results.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'SearchScreen';
  final SearchType searchType;

  const SearchScreen({super.key, this.searchType = SearchType.videos});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum SearchType { videos, books }

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _hasSearched = false;

  void _search(BuildContext scopedContext, String query) {
    setState(() {
      _hasSearched = query.trim().isNotEmpty;
      if (widget.searchType == SearchType.books) {}
    });

    if (widget.searchType == SearchType.videos) {
      scopedContext.read<VideosCubit>().search(query);
    } else {
      scopedContext.read<TextBooksCubit>().search(query);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    if (!_hasSearched) return const SizedBox.shrink();

    if (widget.searchType == SearchType.videos) {
      return BlocBuilder<VideosCubit, VideosState>(
        builder: (context, state) {
          if (state is VideosLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VideosError) {
            return const NoResultsWidget();
          }
          final results = state is VideosSearchLoaded
              ? state.results
              : <VideoModel>[];
          if (results.isEmpty) return const NoResultsWidget();
          return SearchResults(results: results);
        },
      );
    } else {
      return BlocBuilder<TextBooksCubit, TextBooksState>(
        builder: (context, state) {
          if (state is TextBooksLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TextBooksError) {
            return const NoResultsWidget();
          }
          final results = state is TextBooksSearchLoaded
              ? state.results
              : <BookModel>[];
          if (results.isEmpty) return const NoResultsWidget();
          return BooksSearchResults(results: results);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This screen is frequently shown in a bottom sheet (new route), so it must
    // provide its cubits locally to avoid ProviderNotFound errors.
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideosCubit>(create: (_) => sl<VideosCubit>()),
        BlocProvider<TextBooksCubit>(create: (_) => sl<TextBooksCubit>()),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = context.watch<AppThemeProvider>();
          final isDark =
              themeProvider.appTheme == ThemeMode.dark ||
              (themeProvider.appTheme == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness ==
                      Brightness.dark);

          return SizedBox(
            height: 956.h,
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.bg_surface_default_dark
                    : AppColors.bg_surface_default_light,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const HomeIndicator(),
                    SizedBox(height: 24.h),
                    SearchBarWidget(
                      controller: _controller,
                      onChanged: (q) => _search(context, q),
                    ),
                    Expanded(child: _buildBody()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BooksSearchResults extends StatelessWidget {
  final List<BookModel> results;

  const BooksSearchResults({super.key, required this.results});

  Future<void> _openBook(BuildContext context, BookModel book) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    BookModel target = book;

    if (book.id.isNotEmpty && book.chapters.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      try {
        final cubit = sl<TextBooksCubit>();
        target = await cubit.repo.getById(book.id);
      } catch (_) {
        // Keep the original book if fetch fails.
      } finally {
        if (navigator.canPop()) navigator.pop();
      }
    }

    await navigator.push(
      MaterialPageRoute(builder: (_) => ReadBookScreen(book: target)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) return const NoResultsWidget();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.pop(context);
          _openBook(context, results[index]);
        },
        child: BookCardVertical(book: results[index]),
      ),
    );
  }
}
