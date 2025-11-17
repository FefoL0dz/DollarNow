import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../core/error/dollar_exception.dart';
import '../models/dollar_quote_model.dart';

abstract class BcbRemoteDataSource {
  Future<DollarQuoteModel> fetchLatestQuote({
    required String currencyCode,
    required String currencyName,
  });

  Future<List<DollarQuoteModel>> fetchQuoteHistory({
    required String currencyCode,
    required String currencyName,
    required DateTime startDate,
    required DateTime endDate,
  });
}

class BcbRemoteDataSourceImpl implements BcbRemoteDataSource {
  BcbRemoteDataSourceImpl(this.client);

  final http.Client client;
  static const _baseUrl =
      'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata';

  @override
  Future<DollarQuoteModel> fetchLatestQuote({
    required String currencyCode,
    required String currencyName,
  }) async {
    final sanitizedCurrency = currencyCode.toUpperCase();
    final today = DateTime.now();
    for (var dayOffset = 0; dayOffset < 7; dayOffset++) {
      final date = today.subtract(Duration(days: dayOffset));
      final uri = _buildDailyUri(currencyCode: sanitizedCurrency, date: date);
      final response = await client.get(
        uri,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        continue;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final values = decoded['value'] as List<dynamic>?;

      if (values == null || values.isEmpty) {
        continue;
      }

      final firstQuote = values.first as Map<String, dynamic>;
      return DollarQuoteModel.fromJson(
        firstQuote,
        currencyCode: sanitizedCurrency,
        currencyName: currencyName,
      );
    }

    throw const DollarException(
      'Não encontramos cotações recentes do Banco Central. Tente novamente mais tarde.',
    );
  }

  @override
  Future<List<DollarQuoteModel>> fetchQuoteHistory({
    required String currencyCode,
    required String currencyName,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final uri = _buildHistoryUri(
      currencyCode: currencyCode.toUpperCase(),
      startDate: startDate,
      endDate: endDate,
    );
    final response = await client.get(
      uri,
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw const DollarException('Erro ao buscar histórico de cotações.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final values = decoded['value'] as List<dynamic>?;

    if (values == null || values.isEmpty) {
      throw const DollarException(
        'Histórico indisponível no momento. Tente novamente mais tarde.',
      );
    }

    final quotes =
        values
            .map(
              (item) => DollarQuoteModel.fromJson(
                item as Map<String, dynamic>,
                currencyCode: currencyCode.toUpperCase(),
                currencyName: currencyName,
              ),
            )
            .toList()
          ..sort((a, b) => a.quotationTime.compareTo(b.quotationTime));

    return quotes;
  }

  Uri _buildDailyUri({required String currencyCode, required DateTime date}) {
    final formatter = DateFormat('MM-dd-yyyy');
    final formattedDate = formatter.format(date);

    return Uri.parse(
      '$_baseUrl/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)',
    ).replace(
      queryParameters: {
        '@moeda': "'$currencyCode'",
        '@dataCotacao': "'$formattedDate'",
        r'$format': 'json',
        r'$top': '1',
      },
    );
  }

  Uri _buildHistoryUri({
    required String currencyCode,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final formatter = DateFormat('MM-dd-yyyy');
    final start = formatter.format(startDate);
    final end = formatter.format(endDate);

    return Uri.parse(
      '$_baseUrl/CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinal)',
    ).replace(
      queryParameters: {
        '@moeda': "'$currencyCode'",
        '@dataInicial': "'$start'",
        '@dataFinal': "'$end'",
        r'$format': 'json',
      },
    );
  }
}
