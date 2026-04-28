import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
    required this.isDark,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Directionality.of(context) == TextDirection.rtl;

    return AppBar(
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
            if (trailing != null) trailing!,
            Text(title, style: AppTextStyle.medium16TextHeading(context)),
            CustomAppBarButton(onTap: onBack ?? () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.w);
}
