import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dollar_now/model/crypto_coin.dart';
import 'package:dollar_now/service/crypto/crypto_service_interface.dart';

class CoinCapService implements ICryptoService {
  final String _baseUrl = 'https://api.coincap.io/v2';
  final http.Client client;

  CoinCapService({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<CryptoCoin>> fetchTopCoins({int limit = 5}) async {
    final url = '$_baseUrl/assets?limit=$limit';
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];
        return data.map((json) {
          return CryptoCoin(
            id: json['id'] ?? '',
            symbol: (json['symbol'] ?? '').toString().toUpperCase(),
            name: json['name'] ?? '',
            priceUsd: double.tryParse(json['priceUsd'] ?? '0') ?? 0.0,
            change24h: double.tryParse(json['changePercent24Hr'] ?? '0') ?? 0.0,
            imageUrl: 'https://assets.coincap.io/assets/icons/${json['symbol'].toString().toLowerCase()}@2x.png',
          );
        }).toList();
      } else {
        throw Exception('Failed to load coins from CoinCap: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('CoinCap fetch error: $e');
    }
  }
}
