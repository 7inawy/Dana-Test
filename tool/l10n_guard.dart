import 'dart:io';

final _textLiteralRe = RegExp(r"\bText\(\s*'[^']+");
final _constTextLiteralRe = RegExp(r"\bconst\s+Text\(\s*'[^']+");
final _inputDecorationLabelLiteralRe = RegExp(
  r"""labelText:\s*'[^']+""",
);
final _inputDecorationHintLiteralRe = RegExp(r"""hintText:\s*'[^']+""");
final _inputDecorationHelperLiteralRe = RegExp(r"""helperText:\s*'[^']+""");
final _snackBarTextLiteralRe = RegExp(r"""\bSnackBar\([^\)]*Text\(\s*'[^']+""");
final _alertDialogTextLiteralRe = RegExp(
  r"""\bAlertDialog\([^\)]*(title|content):\s*Text\(\s*'[^']+""",
);

bool _shouldIgnoreFile(String path) {
  final normalized = path.replaceAll('\\', '/');
  if (!normalized.endsWith('.dart')) return true;
  if (normalized.contains('/lib/l10n/')) return true; // generated + ARB helpers
  if (normalized.endsWith('.g.dart')) return true;
  if (normalized.endsWith('.freezed.dart')) return true;
  return false;
}

void main(List<String> args) {
  final root = Directory('lib');
  if (!root.existsSync()) {
    stderr.writeln('Expected ./lib directory.');
    exitCode = 2;
    return;
  }

  final issues = <String>[];
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    final path = entity.path;
    if (_shouldIgnoreFile(path)) continue;

    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Allow common non-localized tokens.
      if (line.contains("'—'") ||
          line.contains("'\${") ||
          line.contains(r'$') ||
          line.contains("helperText: ' '")) {
        continue;
      }

      final hit = _textLiteralRe.hasMatch(line) ||
          _constTextLiteralRe.hasMatch(line) ||
          _inputDecorationLabelLiteralRe.hasMatch(line) ||
          _inputDecorationHintLiteralRe.hasMatch(line) ||
          _inputDecorationHelperLiteralRe.hasMatch(line) ||
          _snackBarTextLiteralRe.hasMatch(line) ||
          _alertDialogTextLiteralRe.hasMatch(line);
      if (!hit) continue;

      issues.add('$path:${i + 1}: $line');
    }
  }

  if (issues.isEmpty) {
    stdout.writeln('l10n_guard: OK');
    return;
  }

  stderr.writeln(
    'l10n_guard: Found hardcoded user-facing strings. '
    'Move them to ARB and use context.l10n.*.\n',
  );
  for (final issue in issues.take(200)) {
    stderr.writeln(issue);
  }
  if (issues.length > 200) {
    stderr.writeln('\n... and ${issues.length - 200} more.');
  }
  exitCode = 1;
}

