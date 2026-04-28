import 'package:dana/core/utils/app_raduis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_text_style.dart';
import '../../../../../../../providers/app_theme_provider.dart';
import '../../../../../../Chat_bot/presentation/controller/data/model/message_model.dart';
import 'chat_Back_Button.dart';
import 'doctor_avatar.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Doctor doctor;
  final VoidCallback? onBackPressed;

  const ChatAppBar({super.key, required this.doctor, this.onBackPressed});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 80.h,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppRadius.space_xl,
              vertical: AppRadius.space_sm,
            ),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DoctorAvatar(imageUrl: doctor.imageUrl),
                SizedBox(width: AppRadius.space_sm),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: AppTextStyle.medium16TextHeading(context),
                      ),
                      Text(
                        doctor.specialty,
                        style: AppTextStyle.regular12TextBody(context),
                      ),
                    ],
                  ),
                ),
                ChatBackButton(
                  isRtl: isRtl,
                  onPressed: onBackPressed ?? () => Navigator.maybePop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
