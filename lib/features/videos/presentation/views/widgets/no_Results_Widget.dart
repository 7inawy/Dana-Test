import 'package:dana/core/utils/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';

class NoResultsWidget extends StatelessWidget {
  const NoResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Center(
      child: Column(
        children: [
          SizedBox(height: 92.h),
          Image.asset(
            AppAssets.empty_search,
            width: 192.w,
            height: 160.h,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
          SizedBox(height: 40.h),
          Text(
            l10n.noResults,
            style: AppTextStyle.semibold16TextHeading(context),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.searchHint,
            textAlign: TextAlign.center,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: AppTextStyle.medium12TextBody(context),
          ),
        ],
      ),
    );
  }
}
