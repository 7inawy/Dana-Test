import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/auth/auth_session.dart';
import '../../../../../../../core/di/injection_container.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../providers/app_theme_provider.dart';
import '../../../../../../Chat_bot/presentation/controller/data/model/message_model.dart';
import '../../../../../data/realtime/chat_socket_client.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/doctor_profile_card.dart';
import '../widgets/encryption_Banner.dart';
import '../widgets/messages_list.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatefulWidget {
  final Doctor doctor;
  static const String routeName = 'ChatScreen';

  const ChatScreen({super.key, required this.doctor});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> _messages;
  bool _chatStarted = false;
  late final ChatSocketClient _chatSocket;

  @override
  void initState() {
    super.initState();
    _messages = [];
    _chatSocket = ChatSocketClient(session: sl<AuthSession>());
    _connectSocket();
  }

  Future<void> _connectSocket() async {
    final doctorId = widget.doctor.id?.trim();
    if (doctorId == null || doctorId.isEmpty) {
      // Can't start realtime chat without a doctor id.
      return;
    }
    await _chatSocket.connectAndJoin(
      doctorId: doctorId,
      onMessage: (msg) {
        final text = (msg['message'] ?? '').toString();
        if (text.trim().isEmpty) return;
        final createdAt = msg['createdAt']?.toString();
        final dt = DateTime.tryParse(createdAt ?? '');
        final m = Message(
          id: (msg['_id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
          text: text,
          sender: MessageSender.doctor,
          time: _formatTime(dt ?? DateTime.now()),
          isRead: true,
        );
        if (!mounted) return;
        setState(() {
          _chatStarted = true;
          _messages = [..._messages, m];
        });
      },
    );
  }

  void _handleSend(String text) {
    final clientMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final newMessage = Message(
      id: clientMessageId,
      text: text,
      sender: MessageSender.user,
      time: _formatTime(DateTime.now()),
      isRead: false,
    );
    setState(() {
      _chatStarted = true;
      _messages = [..._messages, newMessage];
    });
    _chatSocket.sendText(text: text, clientMessageId: clientMessageId);
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  void dispose() {
    _chatSocket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final locale = Localizations.localeOf(context).languageCode;
    final isRtl = locale == 'ar';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.bg_surface_subtle_dark
            : AppColors.bg_surface_subtle_light,
        appBar: ChatAppBar(doctor: widget.doctor),
        body: Column(
          children: [
            Expanded(
              child: _chatStarted
                  ? MessagesList(doctor: widget.doctor, messages: _messages)
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 300.h),
                          DoctorProfileCard(doctor: widget.doctor),
                          SizedBox(height: 32.h),
                          const EncryptionBanner(),
                        ],
                      ),
                    ),
            ),
            ChatInputBar(onSend: _handleSend),
          ],
        ),
      ),
    );
  }
}
