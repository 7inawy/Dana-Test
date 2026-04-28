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
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.trim().isNotEmpty);
    });
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
        top: 11.h,
        bottom: 11.h + MediaQuery.of(context).padding.bottom,
        right: 24.w,
        left: 24.w,
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          _hasText
              ? SendButton(onTap: _handleSend)
              : IconBtn(icon: Icons.add_rounded, onTap: () {}, size: 24),
          SizedBox(width: 10.w),
          Expanded(child: InputField(controller: _controller)),
          SizedBox(width: 10.w),
          IconBtn(assetIcon: AppAssets.record, onTap: () {}),
          SizedBox(width: 10.w),
          IconBtn(assetIcon: AppAssets.camera, onTap: () {}), // ← assetIcon
        ],
      ),
    );
  }
}
