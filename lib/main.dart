import 'package:dana/my_app.dart';
import 'package:dana/core/config/app_config.dart';
import 'package:dana/core/log/debug_audit_log.dart';
import 'package:dana/features/auth/login/presentation/google_oauth_deeplink_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dana/providers/app_language_provider.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.validate();

  await DebugAuditLog.init();

  DebugAuditLog.log(
    runId: 'pre-fix',
    hypothesisId: 'H2',
    location: 'lib/main.dart:main',
    message: 'Startup: before DI init()',
    data: {'apiBaseUrl': AppConfig.apiBaseUrl},
  );

  await init();

  // Must be started after DI init() so it can use Dio/AuthSession.
  await GoogleOAuthDeepLinkHandler.start();

  DebugAuditLog.log(
    runId: 'pre-fix',
    hypothesisId: 'H2',
    location: 'lib/main.dart:main',
    message: 'Startup: after DI init()',
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  final themeProvider = AppThemeProvider();
  await themeProvider.loadTheme();

  final languageProvider = AppLanguageProvider();
  await languageProvider.loadLanguage();

  DebugAuditLog.log(
    runId: 'pre-fix',
    hypothesisId: 'H1',
    location: 'lib/main.dart:main',
    message: 'Startup: loaded theme/lang providers',
    data: {
      'themeMode': themeProvider.appTheme.toString(),
      'language': languageProvider.appLanguage,
    },
  );

  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: languageProvider),
      ChangeNotifierProvider.value(value: themeProvider),
    ],
    child: const Dana(),
  );

  // Crash reporting is opt-in via --dart-define=SENTRY_DSN=...
  if (AppConfig.sentryDsn.trim().isEmpty) {
    runApp(app);
    return;
  }

  await SentryFlutter.init((options) {
    options.dsn = AppConfig.sentryDsn;
    options.sendDefaultPii = false;
    options.tracesSampleRate =
        0.0; // enable later if you want performance tracing
  }, appRunner: () => runApp(app));
}

class Dana extends StatelessWidget {
  const Dana({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      builder: (context, child) {
        return MyApp();
      },
    );
  }
}
