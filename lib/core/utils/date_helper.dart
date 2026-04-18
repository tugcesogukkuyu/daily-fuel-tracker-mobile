import 'package:intl/intl.dart';

class DateHelper {
  static final DateFormat dayMonthYearFormatter = DateFormat(
    'd MMMM yyyy',
    'tr_TR',
  );

  static final DateFormat dayMonthHourFormatter = DateFormat(
    'd MMMM HH.mm',
    'tr_TR',
  );

  static final DateFormat monthYearFormatter = DateFormat(
    'MMMM yyyy',
    'tr_TR',
  );

  static String formatDayMonthYear(DateTime date) {
    return dayMonthYearFormatter.format(date);
  }

  static String formatDayMonthHour(DateTime date) {
    return dayMonthHourFormatter.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return monthYearFormatter.format(date);
  }

  static bool isSameDate(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }

  static List<DateTime> getWeekDates(DateTime selectedDate) {
    final int weekday = selectedDate.weekday;
    final DateTime monday = selectedDate.subtract(Duration(days: weekday - 1));

    return List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    );
  }

  static String getShortWeekdayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Pt';
      case DateTime.tuesday:
        return 'Sa';
      case DateTime.wednesday:
        return 'Ça';
      case DateTime.thursday:
        return 'Pe';
      case DateTime.friday:
        return 'Cu';
      case DateTime.saturday:
        return 'Ct';
      case DateTime.sunday:
        return 'Pz';
      default:
        return '';
    }
  }
}
