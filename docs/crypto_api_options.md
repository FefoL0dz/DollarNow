# Free Cryptocurrency API Options

This document outlines the best free cryptocurrency APIs evaluated for the DollarNow application. The goal is to integrate a robust, free, and easy-to-use API to power the `CryptoCoinDashboard` with live prices and market data.

## Top Recommendations

### 1. CoinGecko API (⭐️ Highly Recommended)
CoinGecko is the top choice for this project due to its generous free tier and ease of use.
*   **Key Benefit:** Does **not** require an API key to get started on the public tier.
*   **Features:** Provides live prices, 24h changes, and market caps for over 10,000 coins. Natively supports returning prices converted directly to Brazilian Real (BRL) or USD via its `/simple/price` endpoint, which aligns perfectly with the DollarNow app's focus.
*   **Rate Limits:** Approximately 10-30 requests per minute on the public (no-key) tier, which is more than sufficient for our dashboard.

### 2. CoinMarketCap API
*   **Overview:** The industry standard for cryptocurrency data, known for high reliability and comprehensive market metrics.
*   **Requirements:** Requires signing up for a free developer account to obtain an API Key.
*   **Rate Limits:** The Basic (free) tier grants 10,000 call credits per month.

### 3. Binance Public API
*   **Overview:** Best for extremely fast, raw ticker prices for top coins traded against USDT on the Binance exchange.
*   **Key Benefit:** Keyless access to public endpoints (e.g., `/api/v3/ticker/price`).
*   **Drawbacks:** Prices are tied strictly to Binance trading pairs (like BTC/USDT) rather than a global average index, and it lacks native, direct BRL conversions without additional calculations.

### 4. CoinCap API
*   **Overview:** Another excellent free, no-key-required API.
*   **Features:** Extremely straightforward REST endpoints for getting current fiat values of cryptocurrencies. Great for basic implementations.

---

## Next Steps / Integration Plan
The recommended path forward is to implement the **CoinGecko API**.
1. Create a new service (e.g., `CryptoApiService`) specifically for fetching crypto data.
2. Utilize the `/simple/price` endpoint to fetch Bitcoin (BTC) and Ethereum (ETH) prices in BRL.
3. Update the hardcoded `CryptoCoinDashboard` UI to consume this real-time data.
