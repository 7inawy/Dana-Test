/// Display / parsing helpers for names that sometimes arrive duplicated from APIs
/// (e.g. two identical halves concatenated with no space).
class DisplayNameUtils {
  DisplayNameUtils._();

  /// If [raw] trimmed is two identical halves (`abab` → `ab`), returns one half.
  /// Otherwise returns trimmed [raw] (or empty).
  static String dedupeTwinRepeated(String raw) {
    final t = raw.trim();
    if (t.length < 2 || t.length.isOdd) return t;
    final mid = t.length ~/ 2;
    final first = t.substring(0, mid);
    final second = t.substring(mid);
    if (first == second) return first;
    return t;
  }
}
