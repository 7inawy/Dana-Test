import 'package:dana/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoogleRequestIdScreen extends StatefulWidget {
  static const String routeName = 'GoogleRequestIdScreen';

  const GoogleRequestIdScreen({super.key});

  @override
  State<GoogleRequestIdScreen> createState() => _GoogleRequestIdScreenState();
}

class _GoogleRequestIdScreenState extends State<GoogleRequestIdScreen> {
  final _controller = TextEditingController();

  static final _uuidRe = RegExp(
    r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _normalize(String raw) {
    final m = _uuidRe.firstMatch(raw);
    return (m?.group(0) ?? '').trim();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text ?? '';
    setState(() {
      _controller.text = _normalize(text);
    });
  }

  void _continue() {
    final id = _normalize(_controller.text);
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paste the requestId (UUID) first'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.googleComplete, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Continue Google signup')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'After you finish Google sign-in in the browser, you will be redirected to a page/URL containing a requestId.\n\nPaste that requestId here to continue.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'requestId',
                  hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _paste,
                    icon: const Icon(Icons.paste),
                    label: const Text('Paste'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _continue,
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

