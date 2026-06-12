import 'package:flutter/material.dart';
import 'package:dollar_now/model/crypto_coin.dart';
import 'package:dollar_now/service/crypto/crypto_service_factory.dart';

class CryptoCoinDashboard extends StatefulWidget {
  @override
  _CryptoCoinDashboardState createState() => _CryptoCoinDashboardState();
}

class _CryptoCoinDashboardState extends State<CryptoCoinDashboard> {
  late Future<List<CryptoCoin>> _coinsFuture;

  @override
  void initState() {
    super.initState();
    _fetchCoins();
  }

  void _fetchCoins() {
    setState(() {
      _coinsFuture = CryptoServiceFactory.getActiveService().fetchTopCoins(limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CryptoCoin>>(
      future: _coinsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 40),
                SizedBox(height: 10),
                Text('Failed to load crypto data', style: TextStyle(color: Colors.red)),
                TextButton(
                  onPressed: _fetchCoins,
                  child: Text('Retry'),
                )
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No crypto data available.'));
        }

        final coins = snapshot.data!;
        
        return ListView.builder(
          itemCount: coins.length,
          itemBuilder: (context, index) {
            final coin = coins[index];
            return _buildCoinCard(coin);
          },
        );
      },
    );
  }

  Widget _buildCoinCard(CryptoCoin coin) {
    final isPositive = coin.change24h >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (coin.imageUrl != null)
              Image.network(coin.imageUrl!, width: 40, height: 40, errorBuilder: (c,e,s) => Icon(Icons.monetization_on, size: 40, color: Colors.amber))
            else
              Icon(Icons.monetization_on, size: 40, color: Colors.amber),
            
            SizedBox(width: 15),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(coin.symbol, style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${coin.priceUsd.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: changeColor, size: 14),
                    Text(
                      '${coin.change24h.toStringAsFixed(2)}%',
                      style: TextStyle(color: changeColor, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}