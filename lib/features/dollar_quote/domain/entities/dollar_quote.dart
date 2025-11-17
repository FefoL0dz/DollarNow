import 'package:equatable/equatable.dart';

class DollarQuote extends Equatable {
  const DollarQuote({
    required this.currencyCode,
    required this.currencyName,
    required this.buyPrice,
    required this.sellPrice,
    required this.quotationTime,
  });

  final String currencyCode;
  final String currencyName;
  final double buyPrice;
  final double sellPrice;
  final DateTime quotationTime;

  @override
  List<Object> get props => [
    currencyCode,
    currencyName,
    buyPrice,
    sellPrice,
    quotationTime,
  ];
}
