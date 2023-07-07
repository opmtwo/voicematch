import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;

DateTime parseIsoDate(String date) {
  safePrint('parseIsoDate - input - $date');
  var result = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
  safePrint('parseIsoDate - output - $result');
  return result;
}

String formatIsoDate(String date, String? format, String? timezone) {
  format ??= 'dd MMMM y - hh:mma';
  safePrint('formatIsoDate - input - date = $date - format = $format');
  var inputDate = parseIsoDate(date);
  // var userTimezone = tz.getLocation(timezone ?? 'UTC');
  // var minutes = tz.TZDateTime.now(userTimezone).timeZoneOffset.inMinutes;
  // var outputDate = inputDate.add(Duration(minutes: minutes));
  var outputDate = inputDate
      .add(Duration(minutes: (double.parse(timezone ?? '0') * 60).toInt()));
  var result = DateFormat(format).format(outputDate);
  safePrint('formatIsoDate - output - $result');
  return result;
}

String showLocalTime(
    {required String date,
    String? format = 'HH:mm a (yyyy-MM-dd)',
    bool? verbose = true}) {
  if (verbose == true) {
    safePrint('showLocalTime - date - $date');
  }
  DateTime dateTime = DateTime.parse(date).toLocal();
  String result = DateFormat(format).format(dateTime);
  if (verbose == true) {
    safePrint('showLocalTime - result - $result');
  }
  return result;
}
