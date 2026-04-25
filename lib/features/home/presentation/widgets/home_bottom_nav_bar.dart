import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeBottomNavBar extends StatelessWidget {
  final GlobalKey<CurvedNavigationBarState> navKey;
  final int selectedIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.navKey,
    required this.selectedIndex,
    required this.isDark,
    required this.onTap,
  });

  static const List<String> _icons = [
    'assets/Icons/home_icon.svg',
    'assets/Icons/doctor_icon.svg',
    'assets/Icons/chatbot_icon.svg',
    'assets/Icons/profile_icon.svg',
  ];

  static const List<String> _outlinedIcons = [
    'assets/Icons/home_outlined_icon.svg',
    'assets/Icons/doctor_icon.svg',
    'assets/Icons/chatbot_icon.svg',
    'assets/Icons/profile_outlined_icon.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: navKey,
      index: selectedIndex,
      color: isDark
          ? AppColors.bg_card_default_dark
          : AppColors.bg_card_default_light,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: isDark
          ? AppColors.button_primary_default_dark
          : AppColors.button_primary_default_light,
      items: List.generate(
        _icons.length,
        (index) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedIndex == index
                ? Padding(
                    padding: EdgeInsets.all(8.r),
                    child: SvgPicture.asset(_icons[index], height: 24.r),
                  )
                : Column(
                    children: [
                      SizedBox(height: 8.h),
                      SvgPicture.asset(_outlinedIcons[index], height: 24.r),
                    ],
                  ),
            if (selectedIndex != index)
              Text(
                [
                  context.l10n.home,
                  context.l10n.doctors,
                  context.l10n.chat,
                  context.l10n.account,
                ][index],
                style: AppTextStyle.medium12TextBody(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
