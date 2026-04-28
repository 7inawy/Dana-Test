import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_text_style.dart';
import '../../../../../l10n/app_localizations.dart';

class BooksSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const BooksSectionHeader({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return SizedBox(
      width: 392.w,
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.medium16TextHeading(context)),
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              l10n.viewAll,
              style: AppTextStyle.regular12TextBody(context),
            ),
          ),
        ],
      ),
    );
  }
}
