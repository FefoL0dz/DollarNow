import '../../domain/entities/currency.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({required super.code, required super.name});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    final code = json['simbolo'] as String? ?? json['codigo'] as String?;
    final name = json['nomeFormatado'] as String? ?? json['nome'] as String?;
    if (code == null || name == null) {
      throw const FormatException('Invalid currency payload');
    }
    return CurrencyModel(code: code.trim(), name: name.trim());
  }

  Map<String, dynamic> toJson() => {'codigo': code, 'nome': name};
}
