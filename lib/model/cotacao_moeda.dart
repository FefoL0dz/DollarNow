import 'const_identifiers.dart';

class CotacaoMoeda {
final double? cotacaoCompra;
final double? cotacaoVenda;
final DateTime? dataHoraCotacao;
final double? paridadeCompra;
final double? paridadeVenda;
final String? tipoBoletim;

const CotacaoMoeda({
this.cotacaoCompra,
this.cotacaoVenda,
this.dataHoraCotacao,
this.paridadeCompra,
this.paridadeVenda,
this.tipoBoletim,
});

factory CotacaoMoeda.fromJson(dynamic jsonObject) {
return CotacaoMoeda(
cotacaoCompra: jsonObject[COTACAO_COMPRA],
cotacaoVenda: jsonObject[COTACAO_VENDA],
dataHoraCotacao: DateTime.parse(jsonObject[DATA_HORA_COTACAO].toString()),
paridadeCompra: jsonObject[PARIDADE_COMPRA],
paridadeVenda: jsonObject[PARIDADE_VENDA],
tipoBoletim: jsonObject[TIPO_BOLETIM],
);
}

@override
List<Object?> get props => [
  cotacaoCompra,
  cotacaoVenda,
  dataHoraCotacao,
  paridadeCompra,
  paridadeVenda,
  tipoBoletim,
];
}