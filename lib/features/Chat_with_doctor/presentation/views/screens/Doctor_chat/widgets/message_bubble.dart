import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utils/app_assets.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../providers/app_theme_provider.dart';
import '../../../../../../Chat_bot/presentation/controller/data/model/message_model.dart';

//
// class MessageBubble extends StatefulWidget {
//   final Message message;
//   final bool showAvatar;
//   final bool showTimestamp;
//
//   const MessageBubble({
//     super.key,
//     required this.message,
//     this.showAvatar = false,
//     this.showTimestamp = true,
//   });
//
//   @override
//   State<MessageBubble> createState() => _MessageBubbleState();
// }
//
// class _MessageBubbleState extends State<MessageBubble> {
//   bool get isUser => widget.message.sender == MessageSender.user;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.watch<AppThemeProvider>().appTheme == ThemeMode.dark;
//
//     return Padding(
//       padding: EdgeInsets.only(
//         right: isUser ? 12.w : 48.w,
//         left: isUser ? 48.w : 12.w,
//         bottom: 24.h,
//       ),
//       child: Column(
//         crossAxisAlignment: isUser
//             ? CrossAxisAlignment.end
//             : CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: isUser
//                 ? MainAxisAlignment.end
//                 : MainAxisAlignment.start,
//             children: [
//               if (!isUser && widget.showAvatar) ...[
//                 Container(
//                   width: 28.w,
//                   height: 28.h,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: AssetImage(AppAssets.aiAvater),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 6.w),
//               ],
//               _buildBubble(isDark, context),
//             ],
//           ),
//           if (widget.showTimestamp) ...[
//             SizedBox(height: 4.h),
//             _buildTimestamp(context),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBubble(bool isDark, BuildContext context) {
//     final isRtl = Directionality.of(context) == TextDirection.rtl;
//     final color = isUser
//         ? (isDark ? AppColors.primary_default_dark : AppColors.primary_default_light)
//         : (isDark ? AppColors.bg_card_default_dark : AppColors.bg_card_default_light);
//
//     final tailOnRight = isRtl ? isUser : !isUser;
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           padding: EdgeInsets.only(
//             top: 6.h,
//             bottom: 6.h,
//             right: tailOnRight ? 24.w : 12.w,
//             left: tailOnRight ? 12.w : 24.w,
//           ),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(
//             widget.message.text,
//             style: isUser
//                 ? AppTextStyle.regular12TextBody(context).copyWith(
//               color: const Color(0xFFFFFFFF),
//               height: 1.35,
//             )
//                 : AppTextStyle.regular12TextBody(context).copyWith(
//               color: const Color(0xFF1B2A2C),
//               height: 1.35,
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: tailOnRight ? -0.42.w : null,
//           left: tailOnRight ? null : -0.42.w,
//           child: CustomPaint(
//             size: Size(16.42.w, 20.32.h),
//             painter: BubbleTailPainter(
//               color: color,
//               isUser: isUser,
//               isRtl: isRtl,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimestamp(BuildContext context) {
//     return Text(
//       '${AppLocalizations.of(context)!.messageRead} ${widget.message.time}',
//       style: AppTextStyle.regular12TextBody(context).copyWith(
//         color: const Color(0xFF3C3C43).withOpacity(0.6),
//       ),
//     );
//   }
// }
//
class BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isUser;
  final bool isRtl;

  const BubbleTailPainter({
    required this.color,
    required this.isUser,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isRtl ? isUser : !isUser) {
      path
        ..moveTo(0, 0)
        ..quadraticBezierTo(size.width, 0, size.width, size.height)
        ..lineTo(0, size.height * 0.5)
        ..close();
    } else {
      path
        ..moveTo(size.width, 0)
        ..quadraticBezierTo(0, 0, 0, size.height)
        ..lineTo(size.width, size.height * 0.5)
        ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BubbleTailPainter old) =>
      old.color != color || old.isUser != isUser || old.isRtl != isRtl;
}

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool showAvatar;
  final bool showTimestamp;

  const MessageBubble({
    super.key,
    required this.message,
    this.showAvatar = false,
    this.showTimestamp = true,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool get isUser => widget.message.sender == MessageSender.user;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: isUser ? 0.w : 26.w,
        end: isUser ? 26.w : 0.w,
        bottom: 12.h,
      ),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: isUser
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (!isUser && widget.showAvatar) ...[
                _buildBubble(isDark, context),
                SizedBox(width: 8.w),
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(AppAssets.aiAvatar),
                    ),
                  ),
                ),
              ] else ...[
                _buildBubble(isDark, context),
              ],
            ],
          ),
          if (widget.showTimestamp) ...[
            SizedBox(height: 4.h),
            _buildTimestamp(context),
          ],
        ],
      ),
    );
  }

  Widget _buildBubble(bool isDark, BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final color = isUser
        ? (isDark
              ? AppColors.primary_default_dark
              : AppColors.primary_default_light)
        : (isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light);

    final tailOnRight = !isUser;

    return Flexible(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.message.text,
              softWrap: true,
              style: isUser
                  ? AppTextStyle.regular12TextButton(context)
                  : AppTextStyle.regular12TextHeading(context),
            ),
          ),
          Positioned(
            bottom: 0,
            right: tailOnRight ? -0.42.w : null,
            left: tailOnRight ? null : -0.42.w,
            child: CustomPaint(
              size: Size(16.42.w, 20.32.h),
              painter: BubbleTailPainter(
                color: color,
                isUser: isUser,
                isRtl: isRtl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    return Text(
      '${AppLocalizations.of(context)!.messageRead} ${widget.message.time}',
      style: AppTextStyle.regular12TextBody(
        context,
      ).copyWith(color: const Color(0xFF3C3C43).withAlpha(153)),
    );
  }
}
