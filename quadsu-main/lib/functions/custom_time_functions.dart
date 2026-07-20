import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'print_function.dart';

// String currentTimezone = 'America/Los_Angeles';
String currentTimezone = 'Asia/Kolkata';
String globalAppTimezone = 'America/Los_Angeles';

class CustomTimeFunctions {
  static double calculateTimeDifference(String startTime, String endTime) {
    // Function to parse time strings in "hh:mm a" format
    DateTime parseTime(String time) {
      final parts = time.split(' ');
      final timeParts = parts[0].split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final amPm = parts[1];

      // Adjust for AM/PM
      int adjustedHour = hour;
      if (amPm == 'PM' && hour != 12) {
        adjustedHour += 12;
      } else if (amPm == 'AM' && hour == 12) {
        adjustedHour = 0;
      }

      return DateTime(0, 1, 1, adjustedHour, minute);
    }

    try {
      // Parse the start and end times manually
      DateTime startDateTime = parseTime(startTime);
      DateTime endDateTime = parseTime(endTime);

      // Calculate the difference between the two times
      Duration difference = endDateTime.difference(startDateTime);

      // Convert the difference to hours, including fractional hours
      double hoursDifference = difference.inMinutes / 60.0;

      return hoursDifference;
    } catch (e) {
      // Print the error for debugging
      print("Error parsing time: $e");
      return 0.0; // Return 0 in case of an error
    }
  }

  static String cleanUpString(String input) {
    // Replace non-breaking spaces and other invisible characters
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String convertDateFormat(String inputDate) {
    print("value is that ::::::::::$inputDate");
    // Parse the input date string to a DateTime object
    DateTime dateTime = DateTime.parse(inputDate);
    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
    return formattedDate;
  }

  static String formatDateTime(String dateTimeString) {
    // Parse the input string to DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);
    dateTime = dateTime.subtract(dateTime.timeZoneOffset);
    dateTime = dateTime.add(Duration(minutes: timezoneOffset));

    // Format the DateTime object to the desired format
    DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
    return formatter
        .format(dateTime.toLocal()); // Convert to local time if needed
  }

  static String formatDateTimeInEst(String dateTimeString) {
    // Parse the input string to DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);
    dateTime = dateTime.subtract(dateTime.timeZoneOffset);
    dateTime = dateTime.add(Duration(minutes: timezoneOffset));

    // Format the DateTime object to the desired format
    DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
    return formatter.format(dateTime); // Convert to local time if needed
  }

  static String convertIsoToDate(String isoDate) {
    // Parse the ISO 8601 date string to a DateTime object
    DateTime dateTime = DateTime.parse(isoDate);

    dateTime = dateTime.subtract(dateTime.timeZoneOffset);
    dateTime = dateTime.add(Duration(minutes: timezoneOffset));

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);

    return formattedDate;
  }

  static String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    print('the diff is ${diff.inMilliseconds}');
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "mins"} ago";
    }
    if (diff.inSeconds > 3) {
      return "${diff.inSeconds} ${diff.inSeconds == 1 ? "sec" : "secs"} ago";
    }
    if (diff.inSeconds < 0) {
      return 'Uploading soon';
    }
    return "just now";
  }

  static String getTimeLeft(
      {required DateTime fromDateTime, required DateTime toDateTime}) {
    // Duration diff = fromDateTime.difference(toDateTime);
    Duration diff = toDateTime.difference(fromDateTime);
    // Duration diff = DateTime.now().difference(d);
    myCustomLogStatements('skldfjl $fromDateTime...\n$toDateTime');

    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} left";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} left";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} left";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} left";
    }

    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"}${diff.inMinutes > 0 ? ', ${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "mins"}' : ''}${diff.inSeconds > 0 ? ', ${diff.inSeconds % 60} ${diff.inSeconds == 1 ? "sec" : "secs"}' : ''} left";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "mins"}${diff.inSeconds > 0 ? ', ${diff.inSeconds % 60} ${diff.inSeconds == 1 ? "sec" : "secs"}' : ''} left";
    }
    if (diff.inSeconds > 3) {
      return "${diff.inSeconds} ${diff.inSeconds == 1 ? "sec" : "secs"} left";
    }
    if (diff.inSeconds < 0) {
      return 'Uploading soon';
    }
    return "just now";
  }

  static String getWeekDay(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Sunnn $day';
    }
  }

  static String getMonth(int day) {
    switch (day) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return 'Sunnn $day';
    }
  }

  static List<TimeOfDay> getTimeList(
      {int durationInMinutes = 30,
      int startingHour = 6,
      int endingHour = 23,
      int startingMinute = 0}) {
    List<TimeOfDay> result = [];

    int length = (((endingHour - startingHour) * 60) / 30).floor();
    myCustomPrintStatement('the length is $length');
    for (int i = 0; i < length; i++) {
      int hourBuffer =
          ((startingMinute + (durationInMinutes * i)) / 60).floor();
      myCustomPrintStatement('dsfsk $durationInMinutes...$hourBuffer');
      result.add(TimeOfDay(
          hour: startingHour + hourBuffer,
          minute: (startingMinute + (durationInMinutes * i)) % 60));
    }

    return result;
  }

  static String formatTime(TimeOfDay time) {
    int hour = time.hour;
    int minute = time.minute;
    return '${hour > 9 ? '${hour == 12 ? hour : hour % 12}' : '0$hour'}:${minute > 9 ? '$minute' : '0$minute'}';
  }

  static String formatDateInHHMMDD(DateTime time) {
    return DateFormat('hh:mma, dd MMM, yyyy').format(time);
    // DateFormat.jm
  }

  static String formatTimeIn12Hrs(TimeOfDay time) {
    int hour = time.hour;
    int minute = time.minute;
    return '${hour > 9 ? '${hour == 12 ? hour : hour % 12}' : '0$hour'}:${minute > 9 ? '$minute' : '0$minute'}${hour >= 12 ? 'PM' : 'AM'}';
  }

  static String formatDateMonthAndDate(DateTime date) {
    return DateFormat('MMM d').format(date).toUpperCase();
  }

  static String formatDateMonthAndYear(DateTime? date) {
    try {
      return DateFormat.yMMMd().format(date!).toUpperCase();
    } catch (e) {
      return '';
    }
  }

  static String formatDayDateMonthAndYear(DateTime? date) {
    try {
      return DateFormat.yMMMEd().format(date!).toUpperCase();
    } catch (e) {
      return '';
    }
  }

  static String getTimeFromDate(DateTime? date,
      {String timeFormat = "hh:mm a'"}) {
    try {
      return DateFormat(timeFormat).format(date!).toUpperCase();
    } catch (e) {
      return '';
    }
  }

  static String formatDateddmmyy(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date).toUpperCase();
  }

  static String formatDateNew(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date).toUpperCase();
  }

  static String formatDateNewWithDash(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date).toUpperCase();
  }

  static String formatDateddmmyyhhmmss(DateTime date) {
    return DateFormat('ddMMyyhhmmss').format(date).toUpperCase();
  }

  static String formatDateIndayDateMonthAtTime(DateTime time) {
    return DateFormat('EEE, dd MMM, yyyy, hh:mma').format(time);
    // DateFormat.jm
  }

  static String formatDateInDateMonthNameyear(DateTime time) {
    return DateFormat('dd MMM, yyyy').format(time);
    // DateFormat.jm
  }

  Future<String> getUserTimeZone() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    return currentTimeZone;
  }

  static String convertTimeZone() {
    var not = DateTime.now();
    return not.timeZoneOffset.toString();
    // myCustomLogStatements('d;fls;l ${not.timeZoneOffset}');
  }

  static DateTime convertToCurrentTimeZone(
      DateTime dateTime, String fromTimeZone, String toTimeZone) {
    // Parse the input datetime with the source timezone
    DateTime parsedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .parse(dateTime.toString(), true)
        .toLocal();

    // Convert the datetime to the target timezone
    DateTime convertedDateTime = parsedDateTime.toUtc().add(Duration(
        hours:
            getTimeZoneOffset(toTimeZone) - getTimeZoneOffset(fromTimeZone)));

    return convertedDateTime;
  }

  static int getTimeZoneOffset(String timeZone) {
    DateTime now = DateTime.now();
    if (timeZone == 'UTC') {
      return 0;
    } else {
      String timeZoneOffset = now.toString().split(' ')[5];
      int hours = int.parse(timeZoneOffset.substring(1, 3));
      int minutes = int.parse(timeZoneOffset.substring(3, 5));
      int totalOffsetInMinutes = hours * 60 + minutes;
      return totalOffsetInMinutes;
    }
  }

    static String convertTo24HourFormat(String time12h) {
    // Parse the input string in 12-hour format
    final DateFormat inputFormat =
        DateFormat('hh:mm a'); // Define output format in 24-hour forma
    final DateFormat outputFormat =
        DateFormat('HH:mm'); // Parse the input time string to DateTime object
    final DateTime parsedTime = inputFormat.parse(time12h);
    // Convert the DateTime object to the desired 24-hour format string
    final String time24h = outputFormat.format(parsedTime);
    return time24h;
  }

  static String convertTo12HourFormat(String time24h) {
    // Parse the input string in 12-hour format
    final DateFormat inputFormat =
        DateFormat('HH:mm'); // Define output format in 24-hour forma
    final DateFormat outputFormat =
        DateFormat('hh:mm a'); // Parse the input time string to DateTime object
    final DateTime parsedTime = inputFormat.parse(time24h);
    // Convert the DateTime object to the desired 24-hour format string
    final String time12h = outputFormat.format(parsedTime);
    return time12h;
  }

  static String formatDateTimeWithMonth(String inputDateTime) {
    // Parse the input date-time string
    final DateTime dateTime = DateTime.parse(inputDateTime);

    // Create a DateFormat instance for the desired format
    final DateFormat dateFormat = DateFormat("MMM dd, yyyy 'at' hh:mm a");

    // Format the date-time
    return dateFormat.format(dateTime);
  }

  static String getDayInitial(DateTime date) {
    String weekdayName = DateFormat('EEEE').format(date);
    return weekdayName.toUpperCase();
  }

  static TimeOfDay parseTimeOfDay(String time) {
    final format = DateFormat.Hms(); // Format for "HH:mm:ss"
    final dateTime = format.parse(time);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hours.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
