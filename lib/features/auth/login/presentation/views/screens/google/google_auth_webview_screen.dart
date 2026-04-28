import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart';

import '../../../../../../../core/api/api_endpoint.dart';
import '../../../../../../../core/api/api_response.dart';
import '../../../../../../../core/config/app_config.dart';
import '../../../../../../../core/di/injection_container.dart';

class GoogleAuthWebViewScreen extends StatefulWidget {
  static const String routeName = 'GoogleAuthWebViewScreen';

  final String url;

  const GoogleAuthWebViewScreen({super.key, required this.url});

  @override
  State<GoogleAuthWebViewScreen> createState() => _GoogleAuthWebViewScreenState();
}

class _GoogleAuthWebViewScreenState extends State<GoogleAuthWebViewScreen> {
  late final WebViewController _controller;
  late final Dio _dio;

  static final _uuidRe = RegExp(
    r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
  );

  String? _extractTempKey(dynamic decoded) {
    if (decoded is! Map) return null;
    final direct = decoded['tempKey'] ?? decoded['temp_key'];
    final directStr = direct?.toString().trim();
    if (directStr != null && directStr.isNotEmpty) return directStr;

    final tokenWrapper = decoded['token'];
    if (tokenWrapper is Map) {
      final nested = tokenWrapper['tempKey'] ?? tokenWrapper['temp_key'];
      final s = nested?.toString().trim();
      if (s != null && s.isNotEmpty) return s;
    }
    return null;
  }

  String? _extractAccessToken(dynamic decoded) {
    if (decoded is! Map) return null;
    final accessToken = decoded['accessToken'];
    if (accessToken is Map) {
      final token = accessToken['access_token']?.toString().trim();
      if (token != null && token.isNotEmpty) return token;
    }
    final tokenWrapper = decoded['token'];
    if (tokenWrapper is Map) {
      final nested = tokenWrapper['accessToken'];
      if (nested is Map) {
        final token = nested['access_token']?.toString().trim();
        if (token != null && token.isNotEmpty) return token;
      }
    }
    return null;
  }

  bool _isBackendCallbackUrl(String rawUrl) {
    try {
      final expectedPrefix = '${AppConfig.apiBaseUrl}${ApiEndpoint.googleCallback}';
      final u = Uri.parse(rawUrl);
      return '${u.scheme}://${u.host}${u.path}'.startsWith(expectedPrefix);
    } catch (_) {
      return rawUrl.startsWith('${AppConfig.apiBaseUrl}${ApiEndpoint.googleCallback}');
    }
  }

  Future<void> _handleCallback(String rawUrl) async {
    try {
      final uri = Uri.parse(rawUrl);
      final res = await _dio.getUri(
        uri,
        options: Options(
          followRedirects: false,
          validateStatus: (s) => s != null && s >= 200 && s < 500,
        ),
      );

      final decoded = ApiResponse.decode(res.data);
      final token = _extractAccessToken(decoded);
      if (token != null && token.isNotEmpty) {
        if (!mounted) return;
        Navigator.of(context).pop({'type': 'token', 'value': token});
        return;
      }

      final tempKey = _extractTempKey(decoded);
      if (tempKey != null && tempKey.isNotEmpty) {
        if (!mounted) return;
        Navigator.of(context).pop({'type': 'tempKey', 'value': tempKey});
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop({
        'type': 'error',
        'value': 'Callback did not return token/tempKey (status=${res.statusCode})',
      });
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop({'type': 'error', 'value': e.toString()});
    }
  }

  String? _extractRequestIdFromUrl(String rawUrl) {
    // 1) Prefer explicit requestId param (stable contract).
    try {
      final uri = Uri.parse(rawUrl);
      final qp = uri.queryParameters;
      final direct = (qp['requestId'] ??
              qp['request_id'] ??
              qp['reqId'] ??
              qp['id'])
          ?.trim();
      final directMatch = direct == null ? null : _uuidRe.firstMatch(direct);
      if (directMatch != null) return directMatch.group(0);

      // 2) Some providers put params in fragment: #requestId=...
      final fragment = uri.fragment;
      if (fragment.isNotEmpty) {
        final fragUri = Uri.tryParse('https://x/?$fragment');
        final fragDirect = (fragUri?.queryParameters['requestId'] ??
                fragUri?.queryParameters['request_id'] ??
                fragUri?.queryParameters['reqId'] ??
                fragUri?.queryParameters['id'])
            ?.trim();
        final fragMatch =
            fragDirect == null ? null : _uuidRe.firstMatch(fragDirect);
        if (fragMatch != null) return fragMatch.group(0);
      }
    } catch (_) {
      // fall through to regex scan
    }

    // 3) Fallback: scan the whole URL for a UUID (legacy behavior).
    final m = _uuidRe.firstMatch(rawUrl);
    return m?.group(0);
  }

  bool _isRedirectUriMismatch(String rawUrl) {
    try {
      final uri = Uri.parse(rawUrl);
      final err = uri.queryParameters['error']?.toLowerCase();
      if (err == 'redirect_uri_mismatch') return true;
      return rawUrl.toLowerCase().contains('redirect_uri_mismatch');
    } catch (_) {
      return rawUrl.toLowerCase().contains('redirect_uri_mismatch');
    }
  }

  @override
  void initState() {
    super.initState();
    _dio = sl<Dio>();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (req) {
                if (_isBackendCallbackUrl(req.url)) {
                  _handleCallback(req.url);
                  return NavigationDecision.prevent;
                }
                if (_isRedirectUriMismatch(req.url)) {
                  Navigator.of(context).pop(
                    'ERROR:redirect_uri_mismatch',
                  );
                  return NavigationDecision.prevent;
                }

                final id = _extractRequestIdFromUrl(req.url);
                if (id != null && id.isNotEmpty) {
                  Navigator.of(context).pop(id);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign In')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

