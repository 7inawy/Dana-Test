import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/extensions/localization_extension.dart';
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
        SnackBar(
          content: Text(context.l10n.pasteRequestIdFirst),
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
      appBar: AppBar(title: Text(context.l10n.googleContinueSignupTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.googleContinueSignupDesc),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: context.l10n.requestIdLabel,
                  hintText: context.l10n.requestIdHint,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _paste,
                    icon: const Icon(Icons.paste),
                    label: Text(context.l10n.paste),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _continue,
                    child: Text(context.l10n.continueButton),
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

