import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../providers/app_theme_provider.dart';
import '../../../../Chat_with_doctor/presentation/views/screens/Doctor_chat/widgets/Icon_Btn.dart';
import '../../../../Chat_with_doctor/presentation/views/screens/Doctor_chat/widgets/Input_Field.dart';
import '../../../../Chat_with_doctor/presentation/views/screens/Doctor_chat/widgets/send_Button.dart';

class AIInputBar extends StatefulWidget {
  final Function(String) onSend;
  final bool enabled;

  const AIInputBar({super.key, required this.onSend, this.enabled = true});

  @override
  State<AIInputBar> createState() => _AIInputBarState();
}

class _AIInputBarState extends State<AIInputBar> {
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
    if (!widget.enabled) return;
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
        children: [
          _hasText
              ? SendButton(onTap: _handleSend)
              : IconBtn(icon: Icons.add_rounded, onTap: () {}, size: 24),
          SizedBox(width: 10.w),
          Expanded(child: InputField(controller: _controller)),
        ],
      ),
    );
  }
}
