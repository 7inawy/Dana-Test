import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/utils/app_text_style.dart';
import '../../../../../../Chat_bot/presentation/controller/data/model/message_model.dart';
import 'message_bubble.dart';

//
// class MessagesList extends StatefulWidget {
//   final Doctor doctor;
//   final List<Message> messages;
//   final bool showAvatar;
//
//   const MessagesList({
//     super.key,
//     required this.doctor,
//     required this.messages,
//     this.showAvatar = false,
//   });
//
//   @override
//   State<MessagesList> createState() => _MessagesListState();
// }
//
// class _MessagesListState extends State<MessagesList> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void didUpdateWidget(MessagesList oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.messages.length != oldWidget.messages.length) {
//       _scrollToBottom();
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       controller: _scrollController,
//       padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
//       children: [
//         ...widget.messages.map(
//               (msg) => Padding(
//             padding: EdgeInsets.symmetric(vertical: 2.h),
//             child: MessageBubble(
//               message: msg,
//               showAvatar: widget.showAvatar,
//               showTimestamp: !widget.showAvatar,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class MessagesList extends StatefulWidget {
  final Doctor doctor;
  final List<Message> messages;
  final bool showAvatar;

  const MessagesList({
    super.key,
    required this.doctor,
    required this.messages,
    this.showAvatar = false,
  });

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(MessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Center(
            child: Text(
              'Today',
              style: AppTextStyle.regular12TextBody(context),
            ),
          ),
        ),
        // Messages
        ...widget.messages.map(
          (msg) => Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: MessageBubble(
              message: msg,
              showAvatar: widget.showAvatar,
              showTimestamp: !widget.showAvatar,
            ),
          ),
        ),
      ],
    );
  }
}
