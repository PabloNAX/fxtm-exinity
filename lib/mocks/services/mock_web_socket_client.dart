// lib/mocks/services/mock_web_socket_client.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../../core/services/web_socket_client.dart';
import '../../core/services/connectivity_service.dart';
import '../data/mock_data.dart';

/// Mock implementation of the WebSocketClient for testing purposes.
class MockWebSocketClient extends WebSocketClient {
  final StreamController<dynamic> _controller =
      StreamController<dynamic>.broadcast();
  final Map<String, double> _prices = {};
  Timer? _updateTimer;
  final Random _random = Random();
  final List<String> _subscribedSymbols = [];
  bool _isConnected = false;

  MockWebSocketClient({
    required ConnectivityService connectivityService,
  }) : super(
          apiToken: 'mock_token',
          connectivityService: connectivityService,
        );

  @override
  Future<Stream<dynamic>?> connect() async {
    if (_isConnected) return _controller.stream;

    _isConnected = true;

    // Initialize initial prices
    final initialPairs = MockData.getInitialForexPairs();
    for (var pair in initialPairs) {
      _prices[pair.symbol] = pair.currentPrice;
    }

    // Start timer to simulate real-time updates
    _startUpdateTimer();

    return _controller.stream;
  }

  @override
  void send(String message) {
    try {
      final Map<String, dynamic> data = jsonDecode(message);

      if (data['type'] == 'subscribe') {
        final symbol = data['symbol'] as String;
        if (!_subscribedSymbols.contains(symbol)) {
          _subscribedSymbols.add(symbol);
          print('Subscribed to: $symbol');

          // Send initial update for this symbol
          _sendUpdate(symbol);
        }
      } else if (data['type'] == 'unsubscribe') {
        final symbol = data['symbol'] as String;
        if (symbol == 'all') {
          _subscribedSymbols.clear();
          print('Unsubscribed from all symbols');
        } else if (_subscribedSymbols.contains(symbol)) {
          _subscribedSymbols.remove(symbol);
          print('Unsubscribed from: $symbol');
        }
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_subscribedSymbols.isEmpty) return;

      // Update all subscribed symbols
      for (var symbol in _subscribedSymbols) {
        _sendUpdate(symbol);
      }
    });
  }

  void _sendUpdate(String symbol) {
    if (!_subscribedSymbols.contains(symbol)) return;

    // Generate a new price with a slight change
    final currentPrice = _prices[symbol] ?? 1.0;
    final changePercent = (_random.nextDouble() * 0.004) - 0.002; // ±0.2%
    final newPrice = currentPrice * (1 + changePercent);
    _prices[symbol] = newPrice;

    // Create and send update
    final update = {
      "data": [
        {
          "p": newPrice,
          "s": symbol,
          "t": DateTime.now().millisecondsSinceEpoch,
          "v": 100 + _random.nextInt(900)
        }
      ],
      "type": "trade"
    };

    _controller.add(jsonEncode(update));
    print(
        'Sent update for $symbol: $newPrice (change: ${changePercent * 100}%)');
  }

  @override
  void disconnect() {
    _isConnected = false;
    _updateTimer?.cancel();
  }

  @override
  void dispose() {
    disconnect();
    _subscribedSymbols.clear();
    _controller.close();
  }

  @override
  bool get isConnected => _isConnected;
}
