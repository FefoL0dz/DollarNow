import 'dart:convert';

import 'package:dollar_now/model/const_identifiers.dart';
import 'package:dollar_now/model/cotacao_dolar.dart';
import 'package:dollar_now/model/cotacao_moeda.dart';
import 'package:dollar_now/model/moeda.dart';
import 'package:dollar_now/service/base_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = 'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata';

const TOP_100 = '100';

const JSON_FORMAT = 'json';

class OlindaService extends BaseApiService {
  final http.Client client;

  OlindaService({http.Client? client}) : client = client ?? http.Client();

  Future<List<CotacaoMoeda>> fetchCotacaoMoeda({required Moeda moeda, required String date}) async {
    String selection = '${PARIDADE_COMPRA},${PARIDADE_VENDA},${COTACAO_COMPRA},${COTACAO_VENDA},${DATA_HORA_COTACAO},${TIPO_BOLETIM}';
    String url = '$baseUrl/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?@moeda=\'${moeda.simbolo}\'&@dataCotacao=\'$date\'&\$top=$TOP_100&\$format=$JSON_FORMAT&\$select=$selection';
    List<CotacaoMoeda> cotacoesMoeda = <CotacaoMoeda>[];
    String response = await performRequest(url);
    Map<String, dynamic> map = jsonDecode(response);
    cotacoesMoeda = (map['value'] as List<dynamic>).map((element) =>
        CotacaoMoeda.fromJson(element)).toList();
    return cotacoesMoeda;
  }

  Future<List<CotacaoDolar>> fetchCotacaoDolar({required String date}) async {
    String selection = '${COTACAO_COMPRA},${COTACAO_VENDA},${DATA_HORA_COTACAO}';
    String url = '$baseUrl/CotacaoDolarDia(dataCotacao=@dataCotacao)?@dataCotacao=\'$date\'&\$top=$TOP_100&\$format=$JSON_FORMAT&\$select=$selection';
    List<CotacaoDolar> cotacoesDolar = <CotacaoDolar>[];
    String response = await performRequest(url);
    Map<String, dynamic> map = jsonDecode(response);
    cotacoesDolar = (map['value'] as List<dynamic>).map((element) =>
        CotacaoDolar.fromJson(element)).toList();
    return cotacoesDolar;
  }

  Future<List<CotacaoDolar>> fetchCotacaoDolarPeriodo({required String dataInicial, required String dataFinalCotacao}) async {
    String selection = '${COTACAO_COMPRA},${COTACAO_VENDA},${DATA_HORA_COTACAO}';
    String url = '$baseUrl/CotacaoDolarPeriodo(dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?@dataInicial=\'$dataInicial\'&@dataFinalCotacao=\'$dataFinalCotacao\'&\$top=$TOP_100&\$format=$JSON_FORMAT&\$select=$selection';
    List<CotacaoDolar> cotacoesDolar = <CotacaoDolar>[];
    String response = await performRequest(url);
    Map<String, dynamic> map = jsonDecode(response);
    cotacoesDolar = (map['value'] as List<dynamic>).map((element) =>
        CotacaoDolar.fromJson(element)).toList();
    return cotacoesDolar;
  }

  Future<List<Moeda>> fetchMoedas() async {
    const url = '$baseUrl/Moedas?\$top=$TOP_100&\$format=$JSON_FORMAT&\$select=simbolo,nomeFormatado,tipoMoeda';
    List<Moeda> moedas = <Moeda>[];
    String response = await performRequest(url);
    Map<String, dynamic> map = jsonDecode(response);
    moedas = (map['value'] as List<dynamic>).map((element) =>
            Moeda.fromJson(element)).toList();
    return moedas;
  }

  Future<String> performRequest(String url) async {
    final uri = Uri.parse(url);
    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(url, response.body);
        return response.body;
      } else {
        throw Exception();
      }
    } catch(exception) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(url)) {
        return prefs.getString(url)!;
      }
      throw Exception('Failed to perform request and no cache available: $exception');
    }
  }
}