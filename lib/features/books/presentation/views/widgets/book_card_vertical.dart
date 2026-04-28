import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/book_Model.dart';
import '../screens/read_Book_Screen.dart';
import 'book_cover_image.dart';

class BookCardVertical extends StatelessWidget {
  final BookModel book;

  const BookCardVertical({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.radius_md),
            child: BookCoverImage(
              imageUrl: book.imageUrl,
              width: 92.w,
              height: 100.h,
              clipInWidget: false,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  book.title,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: AppTextStyle.semibold16TextHeading(context),
                ),
                SizedBox(height: 6.h),
                Text(
                  book.description ?? '',
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.medium12TextBody(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  book.author,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  style: AppTextStyle.regular12TextBody(context).copyWith(
                    color: isDark
                        ? AppColors.primary_default_dark
                        : AppColors.primary_default_light,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BooksVerticalList extends StatelessWidget {
  final List<BookModel> books;

  const BooksVerticalList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReadBookScreen(book: books[index])),
        ),
        child: BookCardVertical(book: books[index]),
      ),
    );
  }
}
