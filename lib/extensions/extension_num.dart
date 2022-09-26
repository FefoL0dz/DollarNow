import 'package:intl/intl.dart';

extension NotationNum on num {
  String notation(String locale,
      String customPattern,
      int decimalDigits,
      String symbol) => NumberFormat.currency(
    locale: locale,
    customPattern: customPattern,
    decimalDigits: decimalDigits,
    symbol: symbol,
  ).format(this);
}

extension NotationDouble on double {

  String notation(String locale,
      String customPattern,
      int decimalDigits,
      String symbol) => NumberFormat.currency(
    locale: locale,
    customPattern: customPattern,
    decimalDigits: decimalDigits,
    symbol: symbol,
  ).format(this);

  String notationPtBr(String locale,
      int decimalDigits, String symbol) => NumberFormat.currency(
    locale: locale,
    decimalDigits: decimalDigits,
    symbol: symbol,
  ).format(this);

}