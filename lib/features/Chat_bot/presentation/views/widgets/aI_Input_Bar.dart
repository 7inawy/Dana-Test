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
        top: _kTopPadding.h,
        bottom: _kTopPadding.h + MediaQuery.of(context).padding.bottom,
        right: _kHorizontalPadding.w,
        left: _kHorizontalPadding.w,
      ),
      child: Row(
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
        ],
      ),
    );
  }
}
