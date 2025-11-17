import 'const_identifiers.dart';

class CotacaoDolar {
  final double? cotacaoCompra;
  final double? cotacaoVenda;
  final DateTime? dataHoraCotacao;

  const CotacaoDolar({
    this.cotacaoCompra,
    this.cotacaoVenda,
    this.dataHoraCotacao});

  factory CotacaoDolar.fromJson(dynamic jsonObject) {
    return CotacaoDolar(
      cotacaoCompra: jsonObject[COTACAO_COMPRA],
      cotacaoVenda: jsonObject[COTACAO_VENDA],
      dataHoraCotacao: DateTime.parse(jsonObject[DATA_HORA_COTACAO].toString()),
    );
  }

  @override
  List<Object?> get props => [
    cotacaoCompra,
    cotacaoVenda,
    dataHoraCotacao,
  ];
}