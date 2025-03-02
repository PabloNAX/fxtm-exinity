// lib/mocks/services/mock_web_socket_client.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../../core/services/web_socket_client.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/exceptions/app_error.dart';
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
  bool _isReconnecting = false;

  // Store the connectivity service reference
  final ConnectivityService _connectivityService;
  Timer? _connectivityCheckTimer;

  MockWebSocketClient({
    required ConnectivityService connectivityService,
  })  : _connectivityService = connectivityService,
        super(
          apiToken: 'mock_token',
          connectivityService: connectivityService,
        );

  @override
  Future<Stream<dynamic>?> connect() async {
    print('MockWebSocketClient: Attempting to connect...');

    if (_isConnected) {
      print('MockWebSocketClient: Already connected.');
      return _controller.stream;
    }

    if (_isReconnecting) {
      print('MockWebSocketClient: Already attempting to reconnect.');
      return null;
    }

    // Check connectivity before establishing WebSocket - same as real client
    final hasConnection = await _connectivityService.hasConnection();
    print('MockWebSocketClient: Connectivity check result: $hasConnection');

    if (!hasConnection) {
      print('MockWebSocketClient: No internet connection. Cannot connect.');
      throw AppError.network();
    }

    try {
      _isConnected = true;
      print('MockWebSocketClient: Successfully connected.');

      // Initialize initial prices
      final initialPairs = MockData.getInitialForexPairs();
      for (var pair in initialPairs) {
        _prices[pair.symbol] = pair.currentPrice;
      }

      // Start timer to simulate real-time updates
      _startUpdateTimer();

      // Start periodic connectivity check
      _startConnectivityCheckTimer();

      return _controller.stream;
    } catch (e) {
      _isConnected = false;
      print('MockWebSocketClient: Failed to connect: $e');
      throw AppError.network(e);
    }
  }

  void _startConnectivityCheckTimer() {
    print('MockWebSocketClient: Starting periodic connectivity checks');
    _connectivityCheckTimer?.cancel();
    _connectivityCheckTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      final hasConnection = await _connectivityService.hasConnection();
      print('MockWebSocketClient: Periodic connectivity check: $hasConnection');

      if (!hasConnection && _isConnected) {
        print('MockWebSocketClient: Connection lost! Triggering disconnect.');
        // Simulate connection drop
        _handleConnectionLost();
      } else if (hasConnection && !_isConnected && !_isReconnecting) {
        print(
            'MockWebSocketClient: Connection restored. Attempting to reconnect.');
        _reconnect();
      }
    });
  }

  void _handleConnectionLost() {
    _isConnected = false;
    _updateTimer?.cancel();

    // Notify listeners about the connection error
    _controller.addError(AppError.network('Connection lost'));
    print('MockWebSocketClient: Added error to stream: Connection lost');

    // Attempt to reconnect
    _reconnect();
  }

  void _reconnect() {
    if (_isReconnecting) {
      print('MockWebSocketClient: Already attempting to reconnect.');
      return;
    }

    _isReconnecting = true;
    print('MockWebSocketClient: Preparing to reconnect...');

    // Clean up existing connection
    _updateTimer?.cancel();

    Future.delayed(const Duration(seconds: 5), () async {
      _isReconnecting = false;
      print('MockWebSocketClient: Attempting to reconnect...');
      try {
        await connect();

        // If reconnection successful, resubscribe to previous symbols
        if (_isConnected) {
          print(
              'MockWebSocketClient: Reconnection successful, resubscribing to ${_subscribedSymbols.length} symbols');
          final symbolsToResubscribe = List<String>.from(_subscribedSymbols);
          _subscribedSymbols.clear();

          for (var symbol in symbolsToResubscribe) {
            send(jsonEncode({'type': 'subscribe', 'symbol': symbol}));
          }
        }
      } catch (e) {
        print('MockWebSocketClient: Reconnection attempt failed: $e');
      }
    });
  }

  @override
  void send(String message) {
    print('MockWebSocketClient: Attempting to send message: $message');

    // Check if connected before sending
    if (!_isConnected) {
      print('MockWebSocketClient: Cannot send message, not connected');
      return;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(message);

      if (data['type'] == 'subscribe') {
        final symbol = data['symbol'] as String;
        if (!_subscribedSymbols.contains(symbol)) {
          _subscribedSymbols.add(symbol);
          print('MockWebSocketClient: Subscribed to: $symbol');

          // Send initial update for this symbol
          _sendUpdate(symbol);
        }
      } else if (data['type'] == 'unsubscribe') {
        final symbol = data['symbol'] as String;
        if (symbol == 'all') {
          _subscribedSymbols.clear();
          print('MockWebSocketClient: Unsubscribed from all symbols');
        } else if (_subscribedSymbols.contains(symbol)) {
          _subscribedSymbols.remove(symbol);
          print('MockWebSocketClient: Unsubscribed from: $symbol');
        }
      } else if (data['type'] == 'ping') {
        print('MockWebSocketClient: Received ping, sending pong');
        // Simulate pong response if needed
      }
    } catch (e) {
      print('MockWebSocketClient: Error parsing message: $e');
    }
  }

  void _startUpdateTimer() {
    print('MockWebSocketClient: Starting price update timer');
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isConnected) {
        print(
            'MockWebSocketClient: Not sending updates because connection is closed');
        return;
      }

      if (_subscribedSymbols.isEmpty) return;

      // Update all subscribed symbols
      for (var symbol in _subscribedSymbols) {
        _sendUpdate(symbol);
      }
    });
  }

  void _sendUpdate(String symbol) {
    if (!_isConnected) {
      print('MockWebSocketClient: Cannot send update, not connected');
      return;
    }

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

    try {
      _controller.add(jsonEncode(update));
      print('MockWebSocketClient: Sent update for $symbol: $newPrice');
    } catch (e) {
      print('MockWebSocketClient: Error sending update: $e');
    }
  }

  @override
  void disconnect() {
    print('MockWebSocketClient: Disconnecting...');
    _isConnected = false;
    _updateTimer?.cancel();
    _connectivityCheckTimer?.cancel();
  }

  @override
  void dispose() {
    print('MockWebSocketClient: Disposing...');
    disconnect();
    _subscribedSymbols.clear();
    _controller.close();
  }

  @override
  bool get isConnected => _isConnected;
}
