import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/book_Model.dart';

class BookDetails extends StatelessWidget {
  final BookModel book;
  const BookDetails({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
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
        SizedBox(height: 8.h),

        if (book.description != null) ...[
          Text(
            book.description!,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: AppTextStyle.regular12TextBody(context),
          ),
          SizedBox(height: 8.h),
        ],

        Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Text(
              book.author,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: AppTextStyle.medium12TextHeading(context).copyWith(
                color: isDark
                    ? AppColors.primary_default_dark
                    : AppColors.primary_default_light,
              ),
            ),
            const Spacer(),
            Text(
              '${book.pageCount} ${l10n.page}',
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              style: AppTextStyle.regular12TextBody(context),
            ),
          ],
        ),

        if (book.publishYear != null) ...[
          SizedBox(height: 8.h),
          Text(
            '${l10n.publishedYear} ${book.publishYear}',
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: AppTextStyle.regular12TextBody(context),
          ),
        ],
      ],
    );
  }
}
