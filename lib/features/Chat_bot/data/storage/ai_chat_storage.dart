import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ai_chat_session.dart';
import '../../presentation/controller/data/model/message_model.dart';

class AIChatStorage {
  static const _legacySessionsKey = 'ai_chat_sessions_v1';
  static const _secureSessionsPrefix = 'ai_chat_sessions_v2.user.';
  static const FlutterSecureStorage _secure = FlutterSecureStorage();

  static String _scopedSessionsKey(String userId) =>
      'ai_chat_sessions_v1.user.${userId.trim()}';

  static String _secureKey(String userId) => '$_secureSessionsPrefix${userId.trim()}';

  static Future<void> _clearLegacyKeyIfPresent() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_legacySessionsKey)) {
      // Privacy fix: legacy key was not user-scoped, so it could leak chats
      // between different logins on the same device.
      await prefs.remove(_legacySessionsKey);
    }
  }

  static Future<void> _migratePrefsToSecureIfNeeded({required String userId}) async {
    // One-way best-effort migration. After migration we remove the prefs copy.
    final prefs = await SharedPreferences.getInstance();
    final prefsKey = _scopedSessionsKey(userId);
    final raw = prefs.getString(prefsKey);
    if (raw == null || raw.trim().isEmpty) return;

    try {
      final existing = await _secure.read(key: _secureKey(userId));
      if (existing == null || existing.trim().isEmpty) {
        await _secure.write(key: _secureKey(userId), value: raw);
      }
      await prefs.remove(prefsKey);
    } catch (_) {
      // If secure storage fails, keep legacy prefs as a fallback.
    }
  }

  static Future<List<AIChatSession>> loadSessions({
    required String userId,
  }) async {
    await _clearLegacyKeyIfPresent();
    await _migratePrefsToSecureIfNeeded(userId: userId);

    String? raw;
    try {
      raw = await _secure.read(key: _secureKey(userId));
    } catch (_) {}

    // Fallback to legacy prefs if secure storage isn't available (best-effort).
    raw ??= (await SharedPreferences.getInstance()).getString(_scopedSessionsKey(userId));
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
    try {
      await _secure.delete(key: _secureKey(userId));
    } catch (_) {}

    // Also clear legacy storage locations.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedSessionsKey(userId));
  }

  static Future<void> _saveAll({
    required String userId,
    required List<AIChatSession> sessions,
  }) async {
    final raw = jsonEncode(sessions.map((s) => s.toJson()).toList());
    try {
      await _secure.write(key: _secureKey(userId), value: raw);
      // Best effort: remove legacy prefs copy if it exists.
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_scopedSessionsKey(userId));
      return;
    } catch (_) {
      // Fallback to prefs if secure storage fails.
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedSessionsKey(userId), raw);
  }
}

