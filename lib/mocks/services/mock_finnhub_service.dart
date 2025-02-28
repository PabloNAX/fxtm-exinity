// core/services/mock_finnhub_service.dart
import 'dart:math';
import 'package:fxtm/core/services/finnhub_service.dart';
import 'package:fxtm/data/models/candle_data_api_model.dart';
import 'package:fxtm/data/models/forex_symbols_api_model.dart';

class MockFinhubService implements FinnhubService {
  final Random _random = Random();

  // Base prices for different currency pairs
  final Map<String, double> _basePrices = {
    'OANDA:EUR_USD': 1.0865,
    'OANDA:GBP_USD': 1.2715,
    'OANDA:USD_JPY': 153.75,
    'OANDA:AUD_USD': 0.6615,
    'OANDA:USD_CAD': 1.3645,
    'OANDA:USD_CHF': 0.9035,
    'OANDA:EUR_GBP': 0.8545,
    'OANDA:EUR_JPY': 167.05,
  };

  // Volatility for different time intervals
  final Map<String, double> _volatilityByResolution = {
    '15': 0.0005, // 15 minutes
    '60': 0.0010, // 1 hour
    '240': 0.0020, // 4 hours
    'D': 0.0035, // 1 day
    'W': 0.0080, // 1 week
  };

  @override
  Future<List<ForexSymbolsApiModel>> fetchForexPairs() async {
    // Return list of forex pairs
    return [
      ForexSymbolsApiModel(
        description: 'Euro vs US Dollar',
        displaySymbol: 'EUR/USD',
        symbol: 'OANDA:EUR_USD',
      ),
      ForexSymbolsApiModel(
        description: 'British Pound vs US Dollar',
        displaySymbol: 'GBP/USD',
        symbol: 'OANDA:GBP_USD',
      ),
      ForexSymbolsApiModel(
        description: 'US Dollar vs Japanese Yen',
        displaySymbol: 'USD/JPY',
        symbol: 'OANDA:USD_JPY',
      ),
      ForexSymbolsApiModel(
        description: 'Australian Dollar vs US Dollar',
        displaySymbol: 'AUD/USD',
        symbol: 'OANDA:AUD_USD',
      ),
      ForexSymbolsApiModel(
        description: 'US Dollar vs Canadian Dollar',
        displaySymbol: 'USD/CAD',
        symbol: 'OANDA:USD_CAD',
      ),
      ForexSymbolsApiModel(
        description: 'US Dollar vs Swiss Franc',
        displaySymbol: 'USD/CHF',
        symbol: 'OANDA:USD_CHF',
      ),
      ForexSymbolsApiModel(
        description: 'Euro vs British Pound',
        displaySymbol: 'EUR/GBP',
        symbol: 'OANDA:EUR_GBP',
      ),
      ForexSymbolsApiModel(
        description: 'Euro vs Japanese Yen',
        displaySymbol: 'EUR/JPY',
        symbol: 'OANDA:EUR_JPY',
      ),
    ];
  }

  @override
  Future<CandleDataApiModel> fetchHistoricalData(
    String symbol, {
    String resolution = 'D',
    int? from,
    int? to,
  }) async {
    final now = DateTime.now();
    final List<int> timestamps = [];
    List<double> opens = [];
    List<double> highs = [];
    List<double> lows = [];
    List<double> closes = [];
    List<int> volumes = [];

    // Determine number of data points and time interval
    int dataPoints;
    Duration interval;

    switch (resolution) {
      case '15':
        dataPoints = 96; // 24 hours (96 intervals of 15 minutes)
        interval = Duration(minutes: 15);
        break;
      case '60':
        dataPoints = 48; // 48 hours (48 intervals of 1 hour)
        interval = Duration(hours: 1);
        break;
      case '240':
        dataPoints = 30; // 5 days (30 intervals of 4 hours)
        interval = Duration(hours: 4);
        break;
      case 'D':
        dataPoints = 30; // 30 days
        interval = Duration(days: 1);
        break;
      case 'W':
        dataPoints = 12; // 12 weeks
        interval = Duration(days: 7);
        break;
      default:
        dataPoints = 30; // Default to 30 days
        interval = Duration(days: 1);
        break;
    }

    // Get base price for selected currency pair
    double basePrice = _basePrices[symbol] ?? 1.0;
    double volatility = _volatilityByResolution[resolution] ?? 0.003;

    // Generate realistic data with trend and random fluctuations
    double lastClose = basePrice;

    // Create trend (upward, downward, or sideways)
    double trendDirection = _random.nextDouble() * 2 - 1; // from -1 to 1
    double trendStrength = _random.nextDouble() * 0.5; // from 0 to 0.5

    for (int i = dataPoints - 1; i >= 0; i--) {
      final date = now.subtract(interval * i);
      timestamps.add(date.millisecondsSinceEpoch ~/ 1000);

      // Add random change with trend
      double change = (trendDirection * trendStrength * volatility) +
          ((_random.nextDouble() * 2 - 1) * volatility);

      // For realism, add small correlation with previous value
      if (i < dataPoints - 1) {
        // If previous change was positive, there's a small chance of continuing the trend
        if (closes.last > opens.last && _random.nextDouble() < 0.6) {
          change = change.abs();
        }
        // If previous change was negative, there's a small chance of continuing the trend
        else if (closes.last < opens.last && _random.nextDouble() < 0.6) {
          change = -change.abs();
        }
      }

      double open = lastClose;
      double close = open * (1 + change);

      // Create realistic high and low
      double high =
          max(open, close) * (1 + _random.nextDouble() * volatility * 0.5);
      double low =
          min(open, close) * (1 - _random.nextDouble() * volatility * 0.5);

      // Trading volume - higher during larger price movements
      int volume =
          1000 + (change.abs() * 100000).toInt() + (_random.nextInt(500));

      // Save closing value for next candle
      lastClose = close;

      // Add data to lists
      opens.add(open);
      closes.add(close);
      highs.add(high);
      lows.add(low);
      volumes.add(volume);
    }

    return CandleDataApiModel(
      o: opens,
      h: highs,
      l: lows,
      c: closes,
      t: timestamps,
      v: volumes,
      s: 'ok',
    );
  }
}
