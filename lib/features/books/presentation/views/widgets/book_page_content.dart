import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/book_Model.dart';
import 'book_info_card.dart';

class BookPageContent extends StatelessWidget {
  final BookModel book;
  final String pageText;
  final int pageIndex;
  final String chapterTitle;

  const BookPageContent({
    super.key,
    required this.book,
    required this.pageText,
    required this.pageIndex,
    required this.chapterTitle,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (pageIndex == 0) ...[
            BookInfoCard(book: book),
            SizedBox(height: 12.h),
            if (book.description != null) ...[
              Text(
                book.description!,
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: AppTextStyle.regular12TextBody(context),
              ),
              SizedBox(height: 20.h),
            ],
            Divider(
              height: 1,
              color: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
            ),
            SizedBox(height: 20.h),
          ],

          if (chapterTitle.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  right: isRtl
                      ? BorderSide(
                          color: isDark
                              ? AppColors.primary_default_dark
                              : AppColors.primary_default_light,
                          width: 4,
                        )
                      : BorderSide.none,
                  left: !isRtl
                      ? BorderSide(
                          color: isDark
                              ? AppColors.primary_default_dark
                              : AppColors.primary_default_light,
                          width: 4,
                        )
                      : BorderSide.none,
                ),
                color: isDark
                    ? AppColors.border_card_default_dark.withAlpha(77)
                    : AppColors.border_card_default_light.withAlpha(77),
                borderRadius: BorderRadius.only(
                  topLeft: isRtl
                      ? Radius.circular(AppRadius.radius_sm)
                      : Radius.zero,
                  bottomLeft: isRtl
                      ? Radius.circular(AppRadius.radius_sm)
                      : Radius.zero,
                  topRight: !isRtl
                      ? Radius.circular(AppRadius.radius_sm)
                      : Radius.zero,
                  bottomRight: !isRtl
                      ? Radius.circular(AppRadius.radius_sm)
                      : Radius.zero,
                ),
              ),
              child: Text(
                chapterTitle,
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                style: AppTextStyle.semibold16TextHeading(context),
              ),
            ),
            SizedBox(height: 12.h),
          ],

          Text(
            pageText,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: AppTextStyle.regular12TextBody(context),
          ),
        ],
      ),
    );
  }
}
