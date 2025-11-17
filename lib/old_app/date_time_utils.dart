import 'package:intl/intl.dart';

const FORMAT_US = 'MM-dd-yyyy';
const FORMAT_ptBr = 'dd/MM/yyyy';
const FORMAT_ptBr_HOUR = 'dd/MM/yyyy\nHH:mm';
const FORMAT_HOUR = 'HH:mm';

class DateTimeUtils {

  static DateTime yesterday() {
    var now = DateTime.now();
    var yesterday = DateTime(now.year, now.month, now.day - 1);
    return yesterday;
  }

  static DateTime dayBefore(DateTime dateTime) {
    var dayBefore = DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
    return dayBefore;
  }

  static DateTime usParse(String dateStr) {
    DateFormat outputFormat = DateFormat(FORMAT_US);
    DateTime outputDateString = outputFormat.parse(dateStr);
    return outputDateString;
  }

  static DateTime ptBrParse(String dateStr) {
    DateFormat outputFormat = DateFormat(FORMAT_ptBr_HOUR);
    DateTime outputDateString = outputFormat.parse(dateStr);
    return outputDateString;
  }

  static String usFormat(DateTime dateTime) {
    DateFormat inputFormat = DateFormat(FORMAT_US);
    String dateString = inputFormat.format(dateTime);
    return dateString;
  }

  static String ptBrFormat(DateTime dateTime) {
    DateFormat inputFormat = DateFormat(FORMAT_ptBr);
    String dateString = inputFormat.format(dateTime);
    return dateString;
  }

  static String ptBrHourFormat(DateTime dateTime) {
    DateFormat inputFormat = DateFormat(FORMAT_ptBr_HOUR);
    String dateString = inputFormat.format(dateTime);
    return dateString;
  }

  static String hourFormat(DateTime dateTime) {
    DateFormat inputFormat = DateFormat(FORMAT_HOUR);
    String dateString = inputFormat.format(dateTime);
    return dateString;
  }
}