import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime dt) => DateFormat('dd.MM.yyyy').format(dt);

  static String formatDateTime(DateTime dt) =>
      DateFormat('dd.MM.yyyy HH:mm').format(dt);

  static String formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);

  static String formatRelative(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Hozirgina';
    if (diff.inMinutes < 60) return '${diff.inMinutes} daqiqa oldin';
    if (diff.inHours < 24) return '${diff.inHours} soat oldin';
    if (diff.inDays < 7) return '${diff.inDays} kun oldin';
    return formatDate(dt);
  }
}
