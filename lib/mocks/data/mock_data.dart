// lib/mocks/data/mock_data.dart

import '../../data/models/candle_data_api_model.dart';
import '../../data/models/forex_pair.dart';
import '../../data/models/forex_symbols_api_model.dart';

/// Mock data provider for forex symbols and historical data.
/// AI GENERATED
class MockData {
  // List of forex pairs
  static List<ForexSymbolsApiModel> getForexSymbols() {
    return [
      const ForexSymbolsApiModel(
        description: 'Euro / US Dollar',
        displaySymbol: 'EUR/USD',
        symbol: 'OANDA:EUR_USD',
      ),
      const ForexSymbolsApiModel(
        description: 'British Pound / US Dollar',
        displaySymbol: 'GBP/USD',
        symbol: 'OANDA:GBP_USD',
      ),
      const ForexSymbolsApiModel(
        description: 'US Dollar / Japanese Yen',
        displaySymbol: 'USD/JPY',
        symbol: 'OANDA:USD_JPY',
      ),
      const ForexSymbolsApiModel(
        description: 'Australian Dollar / US Dollar',
        displaySymbol: 'AUD/USD',
        symbol: 'OANDA:AUD_USD',
      ),
      const ForexSymbolsApiModel(
        description: 'US Dollar / Swiss Franc',
        displaySymbol: 'USD/CHF',
        symbol: 'OANDA:USD_CHF',
      ),
    ];
  }

  // Initial data for forex pairs
  static List<ForexPair> getInitialForexPairs() {
    return [
      ForexPair(
        symbol: 'OANDA:EUR_USD',
        currentPrice: 1.0921,
        change: 0.0,
        percentChange: 0.0,
      ),
      ForexPair(
        symbol: 'OANDA:GBP_USD',
        currentPrice: 1.2654,
        change: 0.0,
        percentChange: 0.0,
      ),
      ForexPair(
        symbol: 'OANDA:USD_JPY',
        currentPrice: 151.43,
        change: 0.0,
        percentChange: 0.0,
      ),
      ForexPair(
        symbol: 'OANDA:AUD_USD',
        currentPrice: 0.6543,
        change: 0.0,
        percentChange: 0.0,
      ),
      ForexPair(
        symbol: 'OANDA:USD_CHF',
        currentPrice: 0.9012,
        change: 0.0,
        percentChange: 0.0,
      ),
    ];
  }

  // Generate historical data
  static CandleDataApiModel getHistoricalData(String symbol, {int days = 30}) {
    final now = DateTime.now();
    final List<int> timestamps = [];
    final List<double> opens = [];
    final List<double> highs = [];
    final List<double> lows = [];
    final List<double> closes = [];
    final List<int> volumes = [];

    // Base price depending on the symbol
    double basePrice = 1.0;
    if (symbol == 'OANDA:EUR_USD') basePrice = 1.09;
    if (symbol == 'OANDA:GBP_USD') basePrice = 1.26;
    if (symbol == 'OANDA:USD_JPY') basePrice = 150.0;
    if (symbol == 'OANDA:AUD_USD') basePrice = 0.65;
    if (symbol == 'OANDA:USD_CHF') basePrice = 0.90;

    // Generate data for each day
    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final timestamp = date.millisecondsSinceEpoch ~/ 1000;

      // Add slight randomness to prices
      final random = (date.day % 5 - 2) / 100; // -0.02 to 0.02
      final open = basePrice * (1 + random);
      final close =
          open * (1 + (date.day % 3 - 1) / 200); // slight change
      final high = [open, close].reduce((a, b) => a > b ? a : b) * 1.005;
      final low = [open, close].reduce((a, b) => a < b ? a : b) * 0.995;
      final volume = 1000 + (date.day * 100);

      timestamps.add(timestamp);
      opens.add(open);
      highs.add(high);
      lows.add(low);
      closes.add(close);
      volumes.add(volume);

      // Update base price for the next day
      basePrice = close;
    }

    return CandleDataApiModel(
      c: closes,
      h: highs,
      l: lows,
      o: opens,
      s: 'ok',
      t: timestamps,
      v: volumes,
    );
  }
}
