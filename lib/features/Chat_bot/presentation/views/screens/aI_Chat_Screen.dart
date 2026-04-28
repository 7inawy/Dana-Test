import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/features/Chat_bot/presentation/views/widgets/aI_Chat_AppBar.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../controller/data/model/message_model.dart';
import '../../../../Chat_with_doctor/presentation/views/screens/Doctor_chat/widgets/messages_list.dart';
import '../widgets/aI_Input_Bar.dart';
import '../widgets/aI_Profile_Card.dart';
import '../widgets/aI_Suggested_Questions.dart';
import '../../../data/storage/ai_chat_storage.dart';
import '../../../data/services/ai_chat_service.dart';
import '../../../../../core/auth/auth_session.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../auth/login/data/model/user_model.dart';

class AIChatScreen extends StatefulWidget {
  static const String routeName = 'AIChatScreen';
  final Doctor doctor;
  final String? sessionId;

  const AIChatScreen({super.key, required this.doctor, this.sessionId});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<Message> _messages = [];
  bool _chatStarted = false;
  String? _sessionId;
  String? _conversationId;
  bool _sending = false;
  String? _userId;
  late final AIChatService _service = AIChatService(sl());

  @override
  void initState() {
    super.initState();
    _sessionId = widget.sessionId;
    _hydrate();
  }

  Future<void> _hydrate() async {
    _userId ??= await _resolveUserId();
    final userId = _userId;
    if (userId == null || userId.trim().isEmpty) return;
    if (_sessionId == null) return;
    final session =
        await AIChatStorage.loadSession(userId: userId, sessionId: _sessionId!);
    if (!mounted || session == null) return;

    setState(() {
      _messages
        ..clear()
        ..addAll(session.messages);
      _chatStarted = _messages.isNotEmpty;
      _conversationId = session.conversationId;
    });
  }

  List<String> get _suggestedQuestions => [
    AppLocalizations.of(context)!.suggestedQ1,
    AppLocalizations.of(context)!.suggestedQ2,
    AppLocalizations.of(context)!.suggestedQ3,
    AppLocalizations.of(context)!.suggestedQ4,
    AppLocalizations.of(context)!.suggestedQ5,
  ];

  Future<void> _handleSend(String text) async {
    if (_sending) return;
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: MessageSender.user,
      time: _formatTime(DateTime.now()),
      isRead: false,
    );
    setState(() {
      _chatStarted = true;
      _messages.add(newMessage);
      _sending = true;
    });

    await _persist();

    try {
      final result = await _service.send(
        message: text,
        conversationId: _conversationId,
      );

      _conversationId = result.conversationId;
      final botMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: result.reply,
        sender: MessageSender.doctor,
        time: _formatTime(DateTime.now()),
        isRead: true,
      );

      if (!mounted) return;
      setState(() {
        _messages.add(botMessage);
      });
      await _persist();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  Future<void> _persist() async {
    _userId ??= await _resolveUserId();
    final userId = _userId;
    if (userId == null || userId.trim().isEmpty) return;

    final sid =
        _sessionId ?? await AIChatStorage.createEmptySession(userId: userId);
    _sessionId = sid;
    await AIChatStorage.upsertSession(
      userId: userId,
      sessionId: sid,
      messages: _messages,
      conversationId: _conversationId,
    );
  }

  Future<String?> _resolveUserId() async {
    final token = await sl<AuthSession>().token();
    if (token == null || token.trim().isEmpty) return null;
    final user = UserModel.fromToken(token: token);
    final id = user.id.trim();
    return id.isEmpty ? null : id;
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.bg_card_default_dark
            : AppColors.bg_card_default_light,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 56.w,
        titleSpacing: 0,
        title: AIChatAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Expanded(
                    child: _chatStarted
                        ? MessagesList(
                            doctor: widget.doctor,
                            messages: _messages,
                            showAvatar: true,
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 200.h),
                                const AIProfileCard(),
                                SizedBox(height: 32.h),
                                AISuggestedQuestions(
                                  questions: _suggestedQuestions,
                                  onQuestionTap: _handleSend,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          AIInputBar(onSend: (t) => _handleSend(t), enabled: !_sending),
        ],
      ),
    );
  }
}
