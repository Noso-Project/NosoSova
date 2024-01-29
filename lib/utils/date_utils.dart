import 'package:intl/intl.dart';

class DateUtil {
  static String getUtcTime(int unixTime) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(unixTime * 1000, isUtc: true);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  static getTime(int millisecondsSinceEpoch) {
    DateTime currentTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return '${currentTime.hour}:${(currentTime.minute).toString().padLeft(2, '0')}:${(currentTime.second).toString().padLeft(2, '0')}';
  }
}
