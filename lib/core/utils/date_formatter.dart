import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  // ── Basic formats ──────────────────────────────────────────────────────

  static String formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy', 'es').format(date);

  static String formatTime(DateTime date) =>
      DateFormat('HH:mm', 'es').format(date);

  static String formatDateTime(DateTime date) =>
      DateFormat('dd MMM · HH:mm', 'es').format(date);

  static String formatShortDate(DateTime date) =>
      DateFormat('dd/MM/yyyy', 'es').format(date);

  // ── Relative labels ────────────────────────────────────────────────────

  /// Returns 'Hoy', 'Ayer' or the formatted date.
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Hoy';
    if (d == today.subtract(const Duration(days: 1))) return 'Ayer';
    return formatDate(date);
  }

  // ── Baby age ───────────────────────────────────────────────────────────

  /// Returns a human-readable age string based on birth date.
  static String getAge(DateTime birthDate) {
    final now = DateTime.now();
    final days = now.difference(birthDate).inDays;

    if (days < 0) return '0 días';
    if (days == 0) return 'Recién nacido';
    if (days < 7) return '$days ${days == 1 ? "día" : "días"}';

    final weeks = days ~/ 7;
    if (weeks < 5) return '$weeks ${weeks == 1 ? "semana" : "semanas"}';

    final months = _monthsBetween(birthDate, now);
    if (months < 24) return '$months ${months == 1 ? "mes" : "meses"}';

    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) {
      return '$years ${years == 1 ? "año" : "años"}';
    }
    return '$years ${years == 1 ? "año" : "años"} y $remainingMonths ${remainingMonths == 1 ? "mes" : "meses"}';
  }

  static int _monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  // ── Duration ───────────────────────────────────────────────────────────

  /// Formats a duration as 'Xh Ymin' or 'Ymin'.
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}min';
    if (hours > 0) return '${hours}h';
    return '${minutes}min';
  }

  /// Elapsed time since [start], e.g. 'Hace 2h 15min'.
  static String elapsed(DateTime start) {
    final d = DateTime.now().difference(start);
    return 'Hace ${formatDuration(d)}';
  }

  // ── Weight ─────────────────────────────────────────────────────────────

  /// Shows grams below 1000 g, kilograms above.
  static String formatWeight(double grams) {
    if (grams < 1000) {
      return '${grams.toStringAsFixed(0)} g';
    }
    final kg = grams / 1000;
    return '${kg.toStringAsFixed(2).replaceAll('.', ',')} kg';
  }

  // ── Volume ─────────────────────────────────────────────────────────────

  static String formatVolume(double ml) => '${ml.toStringAsFixed(0)} ml';
}