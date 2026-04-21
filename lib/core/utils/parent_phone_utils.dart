/// Helpers so sign-up, sign-in, and profile flows send the same phone shape the API expects.
class ParentPhoneUtils {
  ParentPhoneUtils._();

  /// Digits only, strip `00` / `20` country prefix when present, ensure Egyptian `01…` style.
  static String normalizeForApi(String raw) {
    var d = raw.replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return raw.trim();

    while (d.startsWith('00')) {
      d = d.substring(2);
    }
    if (d.startsWith('20') && d.length >= 11) {
      d = d.substring(2);
    }
    if (!d.startsWith('0') && d.startsWith('1') && d.length == 10) {
      d = '0$d';
    }
    return d;
  }
}
