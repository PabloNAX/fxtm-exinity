import 'dart:async';
import 'dart:convert';

import 'package:fxtm/core/exceptions/app_error.dart';
import 'package:fxtm/core/services/web_socket_client.dart';

import '../../data/models/forex_pair.dart';
import '../../data/models/forex_update_ws_model.dart';

/// Service for managing WebSocket connections and handling forex price updates.
/// This service handles subscribing to forex pairs, receiving updates, and managing connection states, including reconnection logic.
//TODO simplify the WS service , proper error handling
class WsService {
  final WebSocketClient _wsClient;
  final Map<String, double> _lastPrices = {};
  StreamSubscription? _subscription;
  Timer? _connectionMonitorTimer;
  DateTime? _lastMessageTime;
  static const Duration _maxSilenceDuration = Duration(seconds: 30);

  WsService({required WebSocketClient wsClient}) : _wsClient = wsClient;

  Future<void> subscribeToSymbols(
    List<String> symbols,
    void Function(ForexPair) onPriceUpdate, {
    Function(AppError)? onError, // Add error callback
  }) async {
    try {
      print('Attempting to connect to WebSocket...');
      final stream = await _wsClient.connect();
      if (stream == null) {
        print('Failed to connect to WebSocket.');
        if (onError != null) {
          onError(AppError.network('Unable to establish WebSocket connection'));
        }
        return;
      }

      print('Connected to WebSocket. Subscribing to symbols...');
      _lastMessageTime = DateTime.now();

      // Cancel any existing subscription
      await _subscription?.cancel();

      _subscription = stream.listen(
        (message) {
          _lastMessageTime = DateTime.now(); // Update last message time
          _handleMessage(message, onPriceUpdate);
        },
        onError: (error) {
          print('WebSocket error: $error');
          if (onError != null) {
            onError(AppError.network('WebSocket connection error: $error'));
          }
        },
        onDone: () {
          print('WebSocket connection closed');
          if (onError != null) {
            onError(AppError.network('WebSocket connection closed'));
          }
        },
      );

      // Start connection monitoring
      _startConnectionMonitoring(onError);

      for (final symbol in symbols) {
        _subscribe(symbol);
      }
    } catch (e) {
      print('WebSocket subscription error: $e');
      if (onError != null) {
        onError(AppError.network('WebSocket subscription error: $e'));
      }
      rethrow; // Rethrow to allow Cubit to handle the error
    }
  }

  void _startConnectionMonitoring(Function(AppError)? onError) {
    _connectionMonitorTimer?.cancel();
    _connectionMonitorTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) {
      // Check if we haven't received messages for too long
      if (_lastMessageTime != null) {
        final silenceDuration = DateTime.now().difference(_lastMessageTime!);
        if (silenceDuration > _maxSilenceDuration) {
          print('WebSocket silent for too long: $silenceDuration');
          if (onError != null) {
            onError(AppError.network('Connection lost - no data from server'));
          }

          // Try to reconnect
          _reconnect(onError);
          return;
        }
      }

      // Send ping to check connection
      _sendPing();
    });
  }

  void _sendPing() {
    try {
      _wsClient.send(jsonEncode({'type': 'ping'}));
      print('Sent ping to WebSocket server');
    } catch (e) {
      print('Error sending ping: $e');
    }
  }

  void _reconnect(Function(AppError)? onError) {
    // Disconnect first
    unsubscribeFromAll();

    // Try to reconnect after delay
    Future.delayed(Duration(seconds: 5), () {
      if (_lastPrices.isNotEmpty) {
        subscribeToSymbols(_lastPrices.keys.toList(), (pair) {
          // We need to recreate the onPriceUpdate callback here
        }, onError: onError);
      }
    });
  }

  void _subscribe(String symbol) {
    final message = {'type': 'subscribe', 'symbol': symbol};
    print('Subscribing to symbol: $symbol');
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

          // Update the last price
          _lastPrices[data.symbol] = data.price;

          final pair = ForexPair(
            symbol: data.symbol,
            currentPrice: data.price,
            change: change,
            percentChange: percentChange,
          );

          print(
              'Price update for ${data.symbol}: ${data.price} (change: $change, percentChange: $percentChange)');
          onPriceUpdate(pair);
        }
      }
    } catch (e) {
      _logWebSocketMessage('Error: $e\nMessage: $message', prefix: 'ERROR');
      print('Error parsing message: $e');
    }
  }

  void unsubscribeFromAll() {
    print('Unsubscribing from all symbols...');
    _connectionMonitorTimer?.cancel();
    _subscription?.cancel();

    try {
      _wsClient.send(jsonEncode({'type': 'unsubscribe', 'symbol': 'all'}));
      _wsClient.disconnect();
    } catch (e) {
      print('Error during unsubscribe: $e');
    }
  }

  void dispose() {
    unsubscribeFromAll();
  }
}

void _logWebSocketMessage(dynamic message, {String prefix = ''}) {
  final timestamp = DateTime.now().toIso8601String();
  print('[$timestamp] $prefix: $message');
}
