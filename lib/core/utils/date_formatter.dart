import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String chatTimestamp(DateTime dateTime) {
    final local = dateTime.toLocal();
    final now = DateTime.now();
    final isToday = local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;

    if (isToday) return DateFormat.jm().format(local);

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = local.year == yesterday.year &&
        local.month == yesterday.month &&
        local.day == yesterday.day;
    if (isYesterday) return 'Yesterday';

    if (now.difference(local).inDays < 7) return DateFormat.E().format(local);

    return DateFormat.yMMMd().format(local);
  }

  static String dayDivider(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime.toLocal());
  }
}
