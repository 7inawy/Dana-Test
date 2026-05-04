import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/auth/auth_session.dart';
import '../../../../../../../core/di/injection_container.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../providers/app_theme_provider.dart';
import '../../../../../../Chat_bot/presentation/controller/data/model/message_model.dart';
import '../../../../../data/model/chat_conversation_bootstrap.dart';
import '../../../../../data/realtime/chat_socket_client.dart';
import '../../../../../data/services/doctor_chat_service.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/doctor_profile_card.dart';
import '../widgets/encryption_Banner.dart';
import '../widgets/messages_list.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatefulWidget {
  final Doctor doctor;
  final String? bookingId;
  static const String routeName = 'ChatScreen';

  const ChatScreen({super.key, required this.doctor, required this.bookingId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> _messages;
  bool _chatStarted = false;
  late final ChatSocketClient _chatSocket;
  late final DoctorChatService _chatService;

  bool _isLoading = true;
  String? _error;

  ChatConversationBootstrap? _bootstrap;

  @override
  void initState() {
    super.initState();
    _messages = [];
    _chatSocket = ChatSocketClient(session: sl<AuthSession>());
    _chatService = sl<DoctorChatService>();
    _bootstrapAndConnect();
  }

  Future<void> _bootstrapAndConnect() async {
    final bookingId = widget.bookingId?.trim();
    if (bookingId == null || bookingId.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'Missing bookingId';
      });
      return;
    }

    try {
      // 1) Create conversation from booking -> roomId + ids.
      final convRes = await _chatService.createParentConversationByBooking(
        bookingId: bookingId,
      );
      final boot = ChatConversationBootstrap.tryParse(convRes.data);
      if (boot == null) {
        throw StateError('Invalid conversation bootstrap response');
      }

      // 2) Load history.
      final historyRes = await _chatService.getMessagesByRoom(roomId: boot.roomId);
      final parsedHistory = _parseHistory(historyRes.data);

      // 3) Connect socket and join by (userId, roomId).
      await _chatSocket.connectAndJoin(
        roomId: boot.roomId,
        parentId: boot.parentId,
        doctorId: boot.doctorId,
        onMessage: (msg) {
          final m = _mapIncomingMessage(msg, boot: boot);
          if (m == null || !mounted) return;
          setState(() {
            _chatStarted = true;
            _messages = [..._messages, m];
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _bootstrap = boot;
        _messages = parsedHistory;
        _chatStarted = parsedHistory.isNotEmpty;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _handleSend(String text) {
    final boot = _bootstrap;
    if (boot == null) return;
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

  List<Message> _parseHistory(dynamic raw) {
    try {
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        final response = map['response'];
        final data = response is Map ? response['data'] : null;
        if (data is List) {
          return data
              .whereType<Map>()
              .map((m) => _mapHistoryMessage(Map<String, dynamic>.from(m)))
              .whereType<Message>()
              .toList(growable: false);
        }
      }
    } catch (_) {}
    return <Message>[];
  }

  Message? _mapHistoryMessage(Map<String, dynamic> msg) {
    final text = (msg['message'] ?? '').toString().trim();
    if (text.isEmpty) return null;
    final createdAt = msg['createdAt']?.toString();
    final dt = DateTime.tryParse(createdAt ?? '') ?? DateTime.now();
    final senderModel = (msg['senderModel'] ?? '').toString();
    final sender = senderModel.toLowerCase() == 'parent'
        ? MessageSender.user
        : MessageSender.doctor;
    return Message(
      id: (msg['_id'] ?? dt.millisecondsSinceEpoch).toString(),
      text: text,
      sender: sender,
      time: _formatTime(dt),
      isRead: msg['readAt'] != null || msg['isRead'] == true,
    );
  }

  Message? _mapIncomingMessage(
    Map<String, dynamic> msg, {
    required ChatConversationBootstrap boot,
  }) {
    final text = (msg['message'] ?? '').toString().trim();
    if (text.isEmpty) return null;
    final createdAt = msg['createdAt']?.toString();
    final dt = DateTime.tryParse(createdAt ?? '') ?? DateTime.now();
    final senderModel = (msg['senderModel'] ?? '').toString().trim();

    // Fallback: infer from senderId if senderModel is missing.
    final senderId = (msg['senderId'] ?? '').toString().trim();
    final sender = senderModel.isNotEmpty
        ? (senderModel.toLowerCase() == 'parent'
            ? MessageSender.user
            : MessageSender.doctor)
        : (senderId == boot.parentId ? MessageSender.user : MessageSender.doctor);

    return Message(
      id: (msg['_id'] ?? dt.millisecondsSinceEpoch).toString(),
      text: text,
      sender: sender,
      time: _formatTime(dt),
      isRead: true,
    );
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_error != null
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : (_chatStarted
                          ? MessagesList(
                              doctor: widget.doctor,
                              messages: _messages,
                            )
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
                            ))),
            ),
            ChatInputBar(onSend: _handleSend),
          ],
        ),
      ),
    );
  }
}
