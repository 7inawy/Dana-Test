import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/book_Model.dart';
import '../../cubit/textbooks_cubit.dart';
import '../screens/read_Book_Screen.dart';
import 'book_card_horizontal.dart';

class BooksHorizontalList extends StatelessWidget {
  final List<BookModel> books;

  const BooksHorizontalList({super.key, required this.books});

  Future<void> _openBook(BuildContext context, BookModel book) async {
    final navigator = Navigator.of(context);
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
        // Fallback to the list item if the details call fails.
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
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    return SizedBox(
      height: 230.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: isRtl,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: books.length,
        separatorBuilder: (_, __) => SizedBox(
          width: 8.w,
          child: VerticalDivider(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
          ),
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _openBook(context, books[index]),
          child: BookCardHorizontal(book: books[index]),
        ),
      ),
    );
  }
}
