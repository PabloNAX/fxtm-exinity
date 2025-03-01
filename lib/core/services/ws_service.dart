import 'dart:convert';

import 'package:fxtm/core/services/web_socket_client.dart';

import '../../data/models/forex_pair.dart';
import '../../data/models/forex_update_ws_model.dart';

class WsService {
  final WebSocketClient _wsClient;
  final Map<String, double> _lastPrices = {};

  WsService({required WebSocketClient wsClient}) : _wsClient = wsClient;

  Future<void> subscribeToSymbols(
    List<String> symbols,
    void Function(ForexPair) onPriceUpdate,
  ) async {
    // final stream = _wsClient.connect();
    // if (stream == null) return;

    final stream = await _wsClient.connect();
    if (stream == null) return;

    stream.listen(
      (message) => _handleMessage(message, onPriceUpdate),
      onError: (error) => print('WebSocket error: $error'),
    );

    for (final symbol in symbols) {
      _subscribe(symbol);
    }
  }

  void _subscribe(String symbol) {
    final message = {'type': 'subscribe', 'symbol': symbol};
    _wsClient.send(jsonEncode(message));
  }

  void _handleMessage(dynamic message, Function(ForexPair) onPriceUpdate) {
    _logWebSocketMessage(message, prefix: 'RECEIVED');
    try {
      final Map<String, dynamic> jsonData = jsonDecode(message);

// If we receive a ping, respond with a pong immediately
      if (jsonData['type'] == 'ping') {
        _logWebSocketMessage("pong", prefix: 'SENT');
        _wsClient.send(jsonEncode({'type': 'pong'}));
        return;
      }

      final update = ForexUpdateWsModel.fromJson(jsonDecode(message));

      _logWebSocketMessage(update, prefix: 'PARSED');

      if (update.type == "trade" && update.data.isNotEmpty) {
        for (var data in update.data) {
          final oldPrice = _lastPrices[data.symbol] ?? data.price;
          final change = data.price - oldPrice;
          final percentChange = oldPrice != 0 ? (change / oldPrice) * 100 : 0.0;

          // Обновляем последнюю цену
          _lastPrices[data.symbol] = data.price;

          final pair = ForexPair(
            symbol: data.symbol,
            currentPrice: data.price,
            change: change,
            percentChange: percentChange,
          );

          onPriceUpdate(pair);
        }
      }
    } catch (e) {
      _logWebSocketMessage('Error: $e\nMessage: $message', prefix: 'ERROR');
      print('Error parsing message: $e');
    }
  }

  void unsubscribeFromAll() {
    _wsClient.send(jsonEncode({'type': 'unsubscribe', 'symbol': 'all'}));
    _wsClient.disconnect();
  }
}

void _logWebSocketMessage(dynamic message, {String prefix = ''}) {
  final timestamp = DateTime.now().toIso8601String();
  print('[$timestamp] $prefix: $message');
}
