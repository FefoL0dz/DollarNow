import 'package:hive/hive.dart';

import '../../domain/entities/dollar_quote.dart';

class DollarQuoteModel extends DollarQuote {
  const DollarQuoteModel({
    required super.currencyCode,
    required super.currencyName,
    required super.buyPrice,
    required super.sellPrice,
    required super.quotationTime,
  });

  factory DollarQuoteModel.fromJson(
    Map<String, dynamic> json, {
    required String currencyCode,
    required String currencyName,
  }) {
    final buy = (json['cotacaoCompra'] as num?)?.toDouble();
    final sell = (json['cotacaoVenda'] as num?)?.toDouble();
    final dateString = json['dataHoraCotacao'] as String?;

    if (buy == null || sell == null || dateString == null) {
      throw const FormatException('Incomplete payload from Banco Central');
    }

    return DollarQuoteModel(
      currencyCode: currencyCode,
      currencyName: currencyName,
      buyPrice: buy,
      sellPrice: sell,
      quotationTime: _parseDate(dateString),
    );
  }

  static DateTime _parseDate(String raw) {
    final normalized = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
    return DateTime.parse(normalized);
  }

  Map<String, dynamic> toJson() {
    return {
      'currencyCode': currencyCode,
      'currencyName': currencyName,
      'cotacaoCompra': buyPrice,
      'cotacaoVenda': sellPrice,
      'dataHoraCotacao': quotationTime.toIso8601String(),
    };
  }
}

class DollarQuoteModelAdapter extends TypeAdapter<DollarQuoteModel> {
  @override
  int get typeId => 1;

  @override
  DollarQuoteModel read(BinaryReader reader) {
    final currencyCode = reader.readString();
    final currencyName = reader.readString();
    final buy = reader.readDouble();
    final sell = reader.readDouble();
    final timestamp = reader.readInt();

    return DollarQuoteModel(
      currencyCode: currencyCode,
      currencyName: currencyName,
      buyPrice: buy,
      sellPrice: sell,
      quotationTime: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  @override
  void write(BinaryWriter writer, DollarQuoteModel obj) {
    writer
      ..writeString(obj.currencyCode)
      ..writeString(obj.currencyName)
      ..writeDouble(obj.buyPrice)
      ..writeDouble(obj.sellPrice)
      ..writeInt(obj.quotationTime.millisecondsSinceEpoch);
  }
}
