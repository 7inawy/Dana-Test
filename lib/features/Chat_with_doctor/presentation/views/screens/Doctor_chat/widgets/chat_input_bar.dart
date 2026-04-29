import 'package:dana/core/utils/app_assets.dart';
import 'package:dana/features/Chat_with_doctor/presentation/views/screens/Doctor_chat/widgets/send_Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../providers/app_theme_provider.dart';
import 'Icon_Btn.dart';
import 'Input_Field.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String) onSend;

  const ChatInputBar({super.key, required this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  static const double _kTopPadding = 11;
  static const double _kHorizontalPadding = 24;
  static const double _kGap = 10;
  static const double _kIconSize = 24;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      color: isDark
          ? AppColors.bg_card_default_dark
          : AppColors.bg_card_default_light,
      padding: EdgeInsets.only(
        top: _kTopPadding.h,
        bottom: _kTopPadding.h + MediaQuery.of(context).padding.bottom,
        right: _kHorizontalPadding.w,
        left: _kHorizontalPadding.w,
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              final hasText = value.text.trim().isNotEmpty;
              return hasText
                  ? SendButton(onTap: _handleSend)
                  : IconBtn(
                      icon: Icons.add_rounded,
                      onTap: () {},
                      size: _kIconSize,
                    );
            },
          ),
          SizedBox(width: _kGap.w),
          Expanded(child: InputField(controller: _controller)),
          SizedBox(width: _kGap.w),
          IconBtn(assetIcon: AppAssets.record, onTap: () {}),
          SizedBox(width: _kGap.w),
          IconBtn(assetIcon: AppAssets.camera, onTap: () {}), // ← assetIcon
        ],
      ),
    );
  }
}
