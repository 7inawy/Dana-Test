import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'exceptions.dart';
import '../../l10n/app_localizations.dart';

class ErrorMapper {
  ErrorMapper._();

  static String message(Object error) {
    if (error is ServerException) return error.message;
    if (error is FormatException) return error.message;

    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final msg = data['message'];
        if (msg != null) return msg.toString();
        final response = data['response'];
        if (response is Map && response['message'] != null) {
          return response['message'].toString();
        }
      }
      return error.message ?? 'Network error';
    }

    return error.toString();
  }

  static String localized(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return message(error);

    if (error is ServerException) {
      final msg = error.message.trim();
      return _mapKnownServerMessage(l10n, msg) ?? msg;
    }

    if (error is DioException) {
      final msg = _extractDioMessage(error);
      if (msg != null && msg.trim().isNotEmpty) {
        return _mapKnownServerMessage(l10n, msg.trim()) ?? msg.trim();
      }
      return l10n.networkError;
    }

    final raw = error.toString().trim();
    if (raw.isEmpty) return l10n.unknownError;
    return _mapKnownServerMessage(l10n, raw) ?? l10n.unknownError;
  }

  static String localizeMessage(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return message;
    final msg = message.trim();
    if (msg.isEmpty) return l10n.unknownError;
    return _mapKnownServerMessage(l10n, msg) ??
        _mapKnownClientMessage(l10n, msg) ??
        msg;
  }

  static String? _extractDioMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final msg = data['message']?.toString();
      if (msg != null && msg.trim().isNotEmpty) return msg;
      final response = data['response'];
      if (response is Map) {
        final nested = response['message']?.toString();
        if (nested != null && nested.trim().isNotEmpty) return nested;
        final respData = response['data'];
        if (respData is Map) {
          final deep = respData['message']?.toString();
          if (deep != null && deep.trim().isNotEmpty) return deep;
        }
      }
    }
    return error.message;
  }

  static String? _mapKnownServerMessage(AppLocalizations l10n, String msg) {
    final lower = msg.toLowerCase();
    if (lower.contains('already booked') || lower.contains('date already booked')) {
      return l10n.bookingSlotAlreadyBooked;
    }
    return null;
  }

  static String? _mapKnownClientMessage(AppLocalizations l10n, String msg) {
    final lower = msg.toLowerCase();
    if (lower == 'network error' || lower.contains('socketexception')) {
      return l10n.networkError;
    }
    return null;
  }
}
