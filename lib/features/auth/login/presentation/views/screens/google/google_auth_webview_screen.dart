import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleAuthWebViewScreen extends StatefulWidget {
  static const String routeName = 'GoogleAuthWebViewScreen';

  final String url;

  const GoogleAuthWebViewScreen({super.key, required this.url});

  @override
  State<GoogleAuthWebViewScreen> createState() => _GoogleAuthWebViewScreenState();
}

class _GoogleAuthWebViewScreenState extends State<GoogleAuthWebViewScreen> {
  late final WebViewController _controller;

  static final _uuidRe = RegExp(
    r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
  );

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
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (req) {
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

