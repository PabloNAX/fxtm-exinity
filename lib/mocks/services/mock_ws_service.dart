import 'dart:async';
import 'dart:convert';
import '../../core/exceptions/app_error.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/ws_service.dart';
import '../../data/models/forex_pair.dart';
import 'mock_web_socket_client.dart';

/// Mock implementation of the WebSocket service for testing purposes.
class MockWsService extends WsService {
  final MockWebSocketClient _mockWsClient;
  final Map<String, double> _lastPrices = {};
  final ConnectivityService _connectivityService;
  StreamSubscription? _subscription;
  Timer? _connectivityCheckTimer;
  Function(ForexPair)? _onPriceUpdate;
  Function(AppError)? _onError;

  MockWsService({
    required MockWebSocketClient mockWsClient,
    required ConnectivityService connectivityService,
  })  : _mockWsClient = mockWsClient,
        _connectivityService = connectivityService,
        super(wsClient: mockWsClient);

  @override
  Future<void> subscribeToSymbols(
    List<String> symbols,
    void Function(ForexPair) onPriceUpdate, {
    Function(AppError)? onError,
  }) async {
    _onPriceUpdate = onPriceUpdate;
    _onError = onError;

    try {
      print('MockWsService: Checking connectivity before connecting...');
      final hasConnection = await _connectivityService.hasConnection();
      print('MockWsService: Connectivity check result: $hasConnection');

      if (!hasConnection) {
        print('MockWsService: No internet connection');
        if (onError != null) {
          onError(AppError.network('Нет подключения к интернету'));
        }
        return;
      }

      // Subscribe to updates from the mock client
      print('MockWsService: Attempting to connect...');
      final stream = await _mockWsClient.connect();
      if (stream == null) {
        print('MockWsService: Failed to connect');
        if (onError != null) {
          onError(AppError.network('Не удалось установить соединение'));
        }
        return;
      }

      // Cancel previous subscription if it exists
      await _subscription?.cancel();

      // Subscribe to updates
      _subscription = stream.listen(
        (message) => _handleMessage(message, onPriceUpdate),
        onError: (error) {
          print('MockWsService: WebSocket error: $error');
          if (onError != null) {
            onError(AppError.network('Ошибка WebSocket: $error'));
          }
        },
        onDone: () {
          print('MockWsService: WebSocket connection closed');
          if (onError != null) {
            onError(AppError.network('WebSocket соединение закрыто'));
          }
        },
      );

      // Subscribe to symbols
      for (final symbol in symbols) {
        final subscribeMessage = {'type': 'subscribe', 'symbol': symbol};
        _mockWsClient.send(jsonEncode(subscribeMessage));
      }

      // Start periodic connectivity checks
      _startConnectivityChecks();
    } catch (e) {
      print('MockWsService: Subscription error: $e');
      if (onError != null) {
        onError(AppError.network('Ошибка подписки: $e'));
      }
      rethrow; // Rethrow to allow proper error handling
    }
  }

  void _startConnectivityChecks() {
    _connectivityCheckTimer?.cancel();
    _connectivityCheckTimer =
        Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        final hasConnection = await _connectivityService.hasConnection();
        print('MockWsService: Periodic connectivity check: $hasConnection');

        if (!hasConnection && _onError != null) {
          _onError!(AppError.network('Соединение с интернетом потеряно'));
          // Optional: try to reconnect or handle disconnection
        }
      } catch (e) {
        print('MockWsService: Error during connectivity check: $e');
      }
    });
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
    _connectivityCheckTimer?.cancel();

    try {
      _mockWsClient.send(jsonEncode({'type': 'unsubscribe', 'symbol': 'all'}));
      _mockWsClient.disconnect();
    } catch (e) {
      print('Error during unsubscribe: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _connectivityCheckTimer?.cancel();
    _mockWsClient.disconnect();
  }
}
