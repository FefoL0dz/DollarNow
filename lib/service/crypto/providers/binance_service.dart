import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dollar_now/model/crypto_coin.dart';
import 'package:dollar_now/service/crypto/crypto_service_interface.dart';

class BinanceService implements ICryptoService {
  final String _baseUrl = 'https://api.binance.com/api/v3';
  // Binance requires specific symbols to fetch prices. We'll pre-define top symbols.
  final List<String> _topSymbols = ['BTCUSDT', 'ETHUSDT', 'BNBUSDT', 'SOLUSDT', 'XRPUSDT'];
  final http.Client client;

  BinanceService({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<CryptoCoin>> fetchTopCoins({int limit = 5}) async {
    final symbolsParam = jsonEncode(_topSymbols.take(limit).toList());
    final url = '$_baseUrl/ticker/24hr?symbols=$symbolsParam';
    
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) {
          String symbol = (json['symbol'] ?? '').toString().replaceAll('USDT', '');
          return CryptoCoin(
            id: symbol.toLowerCase(),
            symbol: symbol,
            name: symbol, // Binance doesn't provide names in ticker, use symbol
            priceUsd: double.tryParse(json['lastPrice'] ?? '0') ?? 0.0,
            change24h: double.tryParse(json['priceChangePercent'] ?? '0') ?? 0.0,
            imageUrl: null, // Binance public API doesn't provide images directly
          );
        }).toList();
      } else {
        throw Exception('Failed to load coins from Binance: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Binance fetch error: $e');
    }
  }
}
