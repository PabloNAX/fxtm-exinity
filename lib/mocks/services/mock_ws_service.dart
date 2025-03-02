// lib/mocks/services/mock_ws_service.dart

import 'dart:async';
import 'dart:convert';
import '../../core/services/ws_service.dart';
import '../../data/models/forex_pair.dart';
import 'mock_web_socket_client.dart';

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

    // Подписываемся на обновления от мок-клиента
    final stream = await _mockWsClient.connect();
    if (stream == null) return;

    // Отменяем предыдущую подписку, если она существует
    await _subscription?.cancel();

    // Подписываемся на обновления
    _subscription = stream.listen(
      (message) => _handleMessage(message, onPriceUpdate),
      onError: (error) => print('WebSocket error: $error'),
    );

    // Подписываемся на символы
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

          // Обновляем последнюю цену
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

  // Метод для приостановки обновлений
  Future<void> pauseWebSocket() async {
    await _subscription?.cancel();
    _mockWsClient.disconnect();
  }

  // Метод для возобновления обновлений
  Future<void> resumeWebSocket() async {
    if (_onPriceUpdate != null) {
      final symbols = _lastPrices.keys.toList();
      await subscribeToSymbols(symbols, _onPriceUpdate!);
    }
  }
}
