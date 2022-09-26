import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumberFormattedText extends StatelessWidget {
  final int? number;
  final String? locale;
  final int? decimalDigits;
  final String? customPattern;
  final String? symbol;

  const NumberFormattedText({
    this.number,
    this.locale,
    this.decimalDigits,
    this.customPattern,
    this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        NumberFormat.currency(
          locale: locale,
          customPattern: customPattern,
          decimalDigits: decimalDigits,
          symbol: symbol,
        ).format(number)
    );
  }
}
