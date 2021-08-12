class Months {
  static const months = const [
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

  String _monthh = months[0];

  String get month => _monthh;

  // set month(int monthNum) {
  //   months.forEach((element) {
  //     for (int i = 0; i <= months.length; i++) {
  //       print(i);
  //     }
  //   });
  // }
  static String getMonth(int num) {
    var month = '';
    for (int i = 0; i <= months.length - 1; i++) {
      if ((i + 1) == num) {
        month = months[i];
      }
    }
    return month;
  }
}
