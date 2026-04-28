import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_raduis.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/features/Chat_bot/data/storage/ai_chat_storage.dart';
import 'package:dana/features/Chat_bot/data/model/ai_chat_session.dart';
import 'package:dana/features/Chat_bot/presentation/controller/data/model/message_model.dart';
import 'package:dana/features/Chat_bot/presentation/views/screens/aI_Chat_Screen.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/auth/auth_session.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../auth/login/data/model/user_model.dart';

class AIChatHistoryScreen extends StatefulWidget {
  static const String routeName = 'AIChatHistoryScreen';

  const AIChatHistoryScreen({super.key});

  @override
  State<AIChatHistoryScreen> createState() => _AIChatHistoryScreenState();
}

class _AIChatHistoryScreenState extends State<AIChatHistoryScreen> {
  bool _loading = true;
  List<AIChatSession> sessions = const [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userId = await _resolveUserId();
    if (userId == null) {
      if (!mounted) return;
      setState(() {
        sessions = const [];
        _loading = false;
      });
      return;
    }
    final s = await AIChatStorage.loadSessions(userId: userId);
    if (!mounted) return;
    setState(() {
      sessions = s;
      _loading = false;
    });
  }

  Future<String?> _resolveUserId() async {
    if (_userId != null && _userId!.trim().isNotEmpty) return _userId;
    final token = await sl<AuthSession>().token();
    if (token == null || token.trim().isEmpty) return null;
    final user = UserModel.fromToken(token: token);
    final id = user.id.trim();
    if (id.isEmpty) return null;
    _userId = id;
    return id;
  }

  Future<void> _newChat() async {
    final userId = await _resolveUserId();
    if (userId == null) return;
    final id = await AIChatStorage.createEmptySession(userId: userId);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIChatScreen(
          doctor: getAIDoctor(context),
          sessionId: id,
        ),
      ),
    );
    await _load();
  }

  Future<void> _openChat(String id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIChatScreen(
          doctor: getAIDoctor(context),
          sessionId: id,
        ),
      ),
    );
    await _load();
  }

  Future<void> _deleteChat(String id) async {
    final userId = await _resolveUserId();
    if (userId == null) return;
    await AIChatStorage.deleteSession(userId: userId, sessionId: id);
    await _load();
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
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              CustomAppBarButton(onTap: () => Navigator.pop(context)),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.danaChat,
                  style: AppTextStyle.medium16TextHeading(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: _newChat,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary_default_dark
                        : AppColors.primary_default_light,
                    borderRadius: BorderRadius.circular(AppRadius.radius_full),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.newChat,
                    style: AppTextStyle.semibold12TextButton(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : sessions.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noChatsYet,
                      style: AppTextStyle.regular12TextBody(context),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final s = sessions[index];
                      return _ChatSessionTile(
                        isDark: isDark,
                        title: s.messages.isEmpty
                            ? AppLocalizations.of(context)!.newChat
                            : s.title,
                        preview: s.lastPreview,
                        time: _formatShortTime(s.updatedAt),
                        onTap: () => _openChat(s.id),
                        onDelete: () => _deleteChat(s.id),
                      );
                    },
                  ),
      ),
    );
  }

  String _formatShortTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _ChatSessionTile extends StatelessWidget {
  final bool isDark;
  final String title;
  final String preview;
  final String time;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChatSessionTile({
    required this.isDark,
    required this.title,
    required this.preview,
    required this.time,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light,
          borderRadius: BorderRadius.circular(AppRadius.radius_md),
          border: Border.all(
            color: isDark
                ? AppColors.border_card_default_dark
                : AppColors.border_card_default_light,
            width: AppRadius.stroke_thin,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary_default_dark
                    : AppColors.primary_default_light,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyle.semibold12TextHeading(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        time,
                        style: AppTextStyle.regular8TextBody(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    preview.isEmpty
                        ? AppLocalizations.of(context)!.tapToContinue
                        : preview,
                    style: AppTextStyle.regular12TextHeading(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_outline,
                size: 20.w,
                color: isDark
                    ? AppColors.text_body_dark
                    : AppColors.text_body_light,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

