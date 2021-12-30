import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormatDate {
  static String getDate(Timestamp time, [String? format]) {
    final date = time.toDate();
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return DateFormat(format ?? 'H:m').format(time.toDate()).toString();
    } else if (date.year == today.year) {
      return DateFormat(format ?? 'MMM y').format(time.toDate()).toString();
    } else {
      return DateFormat(format ?? 'd MMM y').format(time.toDate()).toString();
    }
  }
}
