import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../log/app_logger.dart';

String _sha256Hex(Uint8List bytes) => sha256.convert(bytes).toString();

Uint8List _bytesFromCert(X509Certificate cert) {
  // Prefer DER bytes when available; otherwise hash the PEM string bytes.
  final dynamic d = cert;
  final der = d.der;
  if (der is Uint8List) return der;
  return Uint8List.fromList(utf8.encode(cert.pem));
}

void configureDioSecurityImpl(Dio dio) {
  final pins = AppConfig.apiCertPinsSha256();
  if (pins.isEmpty) {
    if (kReleaseMode) {
      AppLogger.warn(
        'API_CERT_PINS_SHA256 is not configured; certificate pinning is disabled.',
      );
    }
    return;
  }

  final apiHost = Uri.tryParse(AppConfig.apiBaseUrl)?.host;
  if (apiHost == null || apiHost.trim().isEmpty) return;

  dio.httpClientAdapter = IOHttpClientAdapter(
    // Keep default platform validation, then additionally require the pin.
    validateCertificate: (cert, host, port) {
      if (host != apiHost) return true;
      if (cert == null) return false;
      try {
        final h = _sha256Hex(_bytesFromCert(cert)).toLowerCase();
        return pins.contains(h);
      } catch (_) {
        return false;
      }
    },
  );
}

