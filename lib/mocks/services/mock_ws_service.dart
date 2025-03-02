// lib/mocks/services/mock_ws_service.dart

import 'dart:async';
import 'dart:convert';
import '../../core/services/ws_service.dart';
import '../../data/models/forex_pair.dart';
import 'mock_web_socket_client.dart';

/// Mock implementation of the WebSocket service for testing purposes.
class MockWsService extends WsService {
  final MockWebSocketClient _mockWsClient;
  final Map<String, double> _lastPrices = {};
  StreamSubscription? _subscription;
  Function(ForexPair)? _onPriceUpdate;

  MockWsService({
    required MockWebSocketClient mockWsClient,
  })  : _mockWsClient = mockWsClient,
        super(wsClient: mockWsClient);

  @override
  Future<void> subscribeToSymbols(
    List<String> symbols,
    void Function(ForexPair) onPriceUpdate,
  ) async {
    _onPriceUpdate = onPriceUpdate;

    // Subscribe to updates from the mock client
    final stream = await _mockWsClient.connect();
    if (stream == null) return;

    // Cancel previous subscription if it exists
    await _subscription?.cancel();

    // Subscribe to updates
    _subscription = stream.listen(
      (message) => _handleMessage(message, onPriceUpdate),
      onError: (error) => print('WebSocket error: $error'),
    );

    // Subscribe to symbols
    for (final symbol in symbols) {
      final subscribeMessage = {'type': 'subscribe', 'symbol': symbol};
      _mockWsClient.send(jsonEncode(subscribeMessage));
    }
  }

  void _handleMessage(dynamic message, Function(ForexPair) onPriceUpdate) {
    print('MOCK WS RECEIVED: $message');
    try {
      final Map<String, dynamic> jsonData = jsonDecode(message);

      if (jsonData['type'] == 'trade' && jsonData['data'] != null) {
        final data = jsonData['data'] as List;
        for (var item in data) {
          final symbol = item['s'] as String;
          final price = item['p'] as double;

          final oldPrice = _lastPrices[symbol] ?? price;
          final change = price - oldPrice;
          final percentChange = oldPrice != 0 ? (change / oldPrice) * 100 : 0.0;

          // Update the last price
          _lastPrices[symbol] = price;

          final pair = ForexPair(
            symbol: symbol,
            currentPrice: price,
            change: change,
            percentChange: percentChange,
          );

          print(
              'MOCK WS UPDATE: $symbol, price: $price, change: $change, percentChange: $percentChange');
          onPriceUpdate(pair);
        }
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  @override
  void unsubscribeFromAll() {
    _subscription?.cancel();
    _mockWsClient.send(jsonEncode({'type': 'unsubscribe', 'symbol': 'all'}));
    _mockWsClient.disconnect();
  }

  // Method to pause updates
  Future<void> pauseWebSocket() async {
    await _subscription?.cancel();
    _mockWsClient.disconnect();
  }

  // Method to resume updates
  Future<void> resumeWebSocket() async {
    if (_onPriceUpdate != null) {
      final symbols = _lastPrices.keys.toList();
      await subscribeToSymbols(symbols, _onPriceUpdate!);
    }
  }
}
