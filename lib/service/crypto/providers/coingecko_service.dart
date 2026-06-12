import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dollar_now/model/crypto_coin.dart';
import 'package:dollar_now/service/crypto/crypto_service_interface.dart';

class CoinGeckoService implements ICryptoService {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';
  final http.Client client;

  CoinGeckoService({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<CryptoCoin>> fetchTopCoins({int limit = 5}) async {
    final url = '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1&sparkline=false';
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) {
          return CryptoCoin(
            id: json['id'] ?? '',
            symbol: (json['symbol'] ?? '').toString().toUpperCase(),
            name: json['name'] ?? '',
            priceUsd: (json['current_price'] ?? 0).toDouble(),
            change24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
            imageUrl: json['image'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load coins from CoinGecko: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('CoinGecko fetch error: $e');
    }
  }
}
