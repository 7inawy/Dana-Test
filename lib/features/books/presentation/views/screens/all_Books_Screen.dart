import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/features/books/presentation/views/screens/read_Book_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../../videos/presentation/views/screens/search_Screen.dart';
import '../../../data/model/book_Model.dart';
import '../../cubit/textbooks_cubit.dart';
import '../widgets/book_card_horizontal.dart';

class AllBooksScreen extends StatelessWidget {
  static const String routeName = 'AllBooksScreen';
  final List<BookModel> books;
  final String sectionTitle;

  const AllBooksScreen({
    super.key,
    required this.books,
    required this.sectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider<TextBooksCubit>.value(
      value: sl<TextBooksCubit>()..load(),
      child: Scaffold(
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
                        value: context.read<TextBooksCubit>(),
                        child: SearchScreen(searchType: SearchType.books),
                      ),
                    ).whenComplete(() {
                      context.read<TextBooksCubit>().load();
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
        backgroundColor: isDark
            ? AppColors.bg_surface_default_dark
            : AppColors.bg_surface_default_light,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: isRtl
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              SizedBox(height: 16.h),
              Text(
                l10n.featuredBooks,
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                style: AppTextStyle.medium16TextHeading(context),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReadBookScreen(book: books[index]),
                      ),
                    ),
                    child: BookCardHorizontal(book: books[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
