
class Moeda {
  final String? simbolo;
  final String? nomeFormatado;
  final String? tipoMoeda;

  static const SIMBOLO = 'simbolo';
  static const NOME_FORMATADO = 'nomeFormatado';
  static const TIPO_MOEDA = 'tipoMoeda';

  const Moeda({
    this.simbolo,
    this.nomeFormatado,
    this.tipoMoeda});

  factory Moeda.fromJson(dynamic jsonObject) {
    return Moeda(
      simbolo: jsonObject[SIMBOLO],
      nomeFormatado: jsonObject[NOME_FORMATADO],
      tipoMoeda: jsonObject[TIPO_MOEDA],
    );
  }

  @override
  List<Object?> get props => [
    simbolo,
    nomeFormatado,
    tipoMoeda,
  ];
}