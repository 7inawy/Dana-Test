import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/log/debug_audit_log.dart';

class AppLanguageProvider extends ChangeNotifier {
  String appLanguage = 'ar';

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    appLanguage = prefs.getString('lang') ?? 'ar';
    DebugAuditLog.log(
      runId: 'pre-fix',
      hypothesisId: 'H1',
      location: 'lib/providers/app_language_provider.dart:loadLanguage',
      message: 'Loaded language preference',
      data: {'lang': appLanguage},
    );
    notifyListeners();
  }

  Future<void> changeLanguage(String newLanguage) async {
    if (appLanguage == newLanguage) return;

    appLanguage = newLanguage;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', newLanguage);

    notifyListeners();
  }
}
