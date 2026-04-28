import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../data/model/book_Model.dart';
import '../../../data/repo/textbooks_repo.dart';
import '../widgets/book_Divider.dart';
import '../widgets/book_info_card.dart';

class ReadBookScreen extends StatefulWidget {
  final BookModel book;
  const ReadBookScreen({super.key, required this.book});

  @override
  State<ReadBookScreen> createState() => _ReadBookScreenState();
}

class _ReadBookScreenState extends State<ReadBookScreen> {
  late final Future<BookModel?> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = _loadBook();
  }

  Future<BookModel?> _loadBook() async {
    final id = widget.book.id.trim();
    if (id.isEmpty) return null;
    try {
      return await sl<TextBooksRepo>().getById(id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

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
                'اقراء الكتاب',
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
      body: FutureBuilder<BookModel?>(
        future: _bookFuture,
        builder: (context, snapshot) {
          final book = snapshot.data ?? widget.book;
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            children: [
              BookInfoCard(book: book),
              SizedBox(height: 16.h),
              if (book.chapters.isEmpty && (book.link?.isNotEmpty == true))
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.bg_card_default_dark
                        : AppColors.bg_card_default_light,
                    borderRadius: BorderRadius.circular(AppRadius.radius_sm),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.description ?? '',
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        style: AppTextStyle.regular12TextBody(context),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _openLink(book.link!),
                          child: Text(
                            'فتح الكتاب',
                            style: AppTextStyle.semibold16TextButton(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.bg_card_default_dark
                        : AppColors.bg_card_default_light,
                    borderRadius: BorderRadius.circular(AppRadius.radius_sm),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: isDark
                                ? AppColors.secondary_default_dark
                                : AppColors.secondary_default_light,
                            size: 6.w,
                          ),
                          Expanded(
                            child: Divider(
                              height: 1,
                              color: isDark
                                  ? AppColors.secondary_default_dark
                                  : AppColors.secondary_default_light,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              height: 1,
                              color: isDark
                                  ? AppColors.secondary_default_dark
                                  : AppColors.secondary_default_light,
                            ),
                          ),
                          Icon(
                            Icons.circle,
                            color: isDark
                                ? AppColors.secondary_default_dark
                                : AppColors.secondary_default_light,
                            size: 6.w,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      ...book.chapters.asMap().entries.map((entry) {
                        final index = entry.key;
                        final chapter = entry.value;
                        return Column(
                          crossAxisAlignment: isRtl
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapter.title,
                              textAlign:
                                  isRtl ? TextAlign.right : TextAlign.left,
                              textDirection: isRtl
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style:
                                  AppTextStyle.semibold16TextHeading(context),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              chapter.body,
                              textAlign:
                                  isRtl ? TextAlign.right : TextAlign.left,
                              textDirection: isRtl
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: AppTextStyle.regular12TextBody(context),
                            ),
                            SizedBox(height: 32.h),
                            BookDivider(pageNumber: index + 1),
                            SizedBox(height: 32.h),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
