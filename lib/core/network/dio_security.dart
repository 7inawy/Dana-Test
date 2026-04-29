import 'package:dio/dio.dart';

import 'dio_security_stub.dart'
    if (dart.library.io) 'dio_security_io.dart';

/// Applies optional transport security hardening (e.g. certificate pinning).
///
/// - On non-IO platforms (web), this is a no-op.
/// - On IO platforms, pinning is applied only when pins are configured.
void configureDioSecurity(Dio dio) {
  configureDioSecurityImpl(dio);
}

