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

String getNow({String format = 'yyyy-MM-dd'}) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat(format).format(now);
  return formattedDate.toString();
}

String gethumanTimeDiff(String isoTimestamp) {
  DateTime now = DateTime.now();
  DateTime dateTime = DateTime.parse(isoTimestamp).toLocal();

  String formattedDateTime;
  if (isSameDay(dateTime, now)) {
    // Today
    formattedDateTime = DateFormat.jm().format(dateTime);
    formattedDateTime = 'Today at $formattedDateTime';
  } else if (isYesterday(dateTime, now)) {
    // Yesterday
    formattedDateTime = DateFormat.jm().format(dateTime);
    formattedDateTime = 'Yesterday at $formattedDateTime';
  } else if (isSameMonth(dateTime, now)) {
    // Within the same month
    int daysDifference = now.difference(dateTime).inDays;
    formattedDateTime =
        '$daysDifference days ago at ${DateFormat.jm().format(dateTime)}';
  } else {
    // Different month
    int monthsDifference =
        (now.year - dateTime.year) * 12 + now.month - dateTime.month;
    formattedDateTime =
        '$monthsDifference months ago at ${DateFormat.jm().format(dateTime)}';
  }

  return formattedDateTime;
}

bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
  return dateTime1.year == dateTime2.year &&
      dateTime1.month == dateTime2.month &&
      dateTime1.day == dateTime2.day;
}

bool isYesterday(DateTime dateTime1, DateTime dateTime2) {
  DateTime yesterday = dateTime2.subtract(const Duration(days: 1));
  return isSameDay(dateTime1, yesterday);
}

bool isSameMonth(DateTime dateTime1, DateTime dateTime2) {
  return dateTime1.year == dateTime2.year && dateTime1.month == dateTime2.month;
}
