import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/ai_chat_session.dart';
import '../../presentation/controller/data/model/message_model.dart';

class AIChatStorage {
  static const _legacySessionsKey = 'ai_chat_sessions_v1';

  static String _scopedSessionsKey(String userId) =>
      'ai_chat_sessions_v1.user.${userId.trim()}';

  static Future<void> _clearLegacyKeyIfPresent() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_legacySessionsKey)) {
      // Privacy fix: legacy key was not user-scoped, so it could leak chats
      // between different logins on the same device.
      await prefs.remove(_legacySessionsKey);
    }
  }

  static Future<List<AIChatSession>> loadSessions({
    required String userId,
  }) async {
    await _clearLegacyKeyIfPresent();
    final prefs = await SharedPreferences.getInstance();
    final key = _scopedSessionsKey(userId);
    final raw = prefs.getString(key);
    if (raw == null || raw.trim().isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      final sessions = <AIChatSession>[];
      for (final item in decoded) {
        if (item is Map) {
          sessions.add(AIChatSession.fromJson(item.cast<String, dynamic>()));
        }
      }
      sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return sessions;
    } catch (_) {
      return [];
    }
  }

  static Future<AIChatSession?> loadSession({
    required String userId,
    required String sessionId,
  }) async {
    final sessions = await loadSessions(userId: userId);
    try {
      return sessions.firstWhere((s) => s.id == sessionId);
    } catch (_) {
      return null;
    }
  }

  static Future<String> createEmptySession({required String userId}) async {
    await _clearLegacyKeyIfPresent();
    final now = DateTime.now();
    final session = AIChatSession(
      id: now.millisecondsSinceEpoch.toString(),
      conversationId: null,
      createdAt: now,
      updatedAt: now,
      messages: const <Message>[],
    );
    final sessions = await loadSessions(userId: userId);
    final updated = [session, ...sessions];
    await _saveAll(userId: userId, sessions: updated);
    return session.id;
  }

  static Future<void> upsertSession({
    required String userId,
    required String sessionId,
    required List<Message> messages,
    String? conversationId,
  }) async {
    await _clearLegacyKeyIfPresent();
    final sessions = await loadSessions(userId: userId);
    final now = DateTime.now();

    final idx = sessions.indexWhere((s) => s.id == sessionId);
    final next = AIChatSession(
      id: sessionId,
      conversationId: conversationId ?? (idx >= 0 ? sessions[idx].conversationId : null),
      createdAt: idx >= 0 ? sessions[idx].createdAt : now,
      updatedAt: now,
      messages: messages,
    );

    final updated = <AIChatSession>[
      next,
      ...sessions.where((s) => s.id != sessionId),
    ];
    await _saveAll(userId: userId, sessions: updated);
  }

  static Future<void> deleteSession({
    required String userId,
    required String sessionId,
  }) async {
    await _clearLegacyKeyIfPresent();
    final sessions = await loadSessions(userId: userId);
    final updated = sessions.where((s) => s.id != sessionId).toList();
    await _saveAll(userId: userId, sessions: updated);
  }

  static Future<void> clearAllForUser({required String userId}) async {
    await _clearLegacyKeyIfPresent();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedSessionsKey(userId));
  }

  static Future<void> _saveAll({
    required String userId,
    required List<AIChatSession> sessions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_scopedSessionsKey(userId), raw);
  }
}

