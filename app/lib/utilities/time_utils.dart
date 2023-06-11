import 'package:intl/intl.dart';

extension TimeFormatting on int {
  String toMMSS() {
    final formatter = NumberFormat("00");
    final minutes = this ~/ 60;
    final remainingSeconds = this % 60;
    return "${formatter.format(minutes)}:${formatter.format(remainingSeconds)}";
  }
}


extension DateExetnsions on DateTime {
  bool isSameDayAs(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }
}
