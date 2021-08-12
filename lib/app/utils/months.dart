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
