import 'package:flutter/foundation.dart';

/// Minimal production-safe logger.
///
/// - In **release**: only logs warnings/errors (to reduce PII risk + noise).
/// - In **debug/profile**: logs everything.
class AppLogger {
  AppLogger._();

  static void debug(String message) {
    if (kReleaseMode) return;
    // ignore: avoid_print
    print('[D] $message');
  }

  static void info(String message) {
    if (kReleaseMode) return;
    // ignore: avoid_print
    print('[I] $message');
  }

  static void warn(String message) {
    if (kReleaseMode) {
      // ignore: avoid_print
      print('[W] $message');
      return;
    }
    // ignore: avoid_print
    print('[W] $message');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    final suffix = [
      if (error != null) ' error=$error',
      if (stackTrace != null && !kReleaseMode) '\n$stackTrace',
    ].join();

    // ignore: avoid_print
    print('[E] $message$suffix');
  }
}
