import 'package:cloud_firestore/cloud_firestore.dart';

class Months {
  static const months = [
    'Jan',
    'Feb',
    'March',
    'April',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String getMonth(int num) {
    var month = '';
    for (int i = 0; i <= months.length - 1; i++) {
      if ((i + 1) == num) {
        month = months[i];
      }
    }
    return month;
  }

  static String getDate(Timestamp time) =>
      '${time.toDate().day} ${Months.getMonth(time.toDate().month)} ${time.toDate().year}';

  static String getTime(Timestamp time) =>
      '${time.toDate().hour}:${time.toDate().minute}';

  static String completeDate(Timestamp time) =>
      '${getDate(time)}, ${getTime(time)}';
}
