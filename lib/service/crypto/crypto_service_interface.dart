import 'package:dollar_now/model/crypto_coin.dart';

abstract class ICryptoService {
  /// Fetches the top coins from the implemented provider.
  /// Implementations should map the API specific responses to the [CryptoCoin] model.
  Future<List<CryptoCoin>> fetchTopCoins({int limit = 5});
}
