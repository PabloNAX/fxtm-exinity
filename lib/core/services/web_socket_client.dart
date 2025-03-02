// lib/core/services/web_socket_client.dart

import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import '../exceptions/forex_exception.dart';
import 'connectivity_service.dart';

class WebSocketClient {
  final String apiToken;
  final ConnectivityService _connectivityService;
  static const String baseUrl = 'wss://ws.finnhub.io';

  WebSocketClient({
    required this.apiToken,
    required ConnectivityService connectivityService,
  }) : _connectivityService = connectivityService;

  WebSocketChannel? _channel;
  StreamController<dynamic>? _controller;
  Timer? _pingTimer;
  bool _isConnected = false;
  bool _isReconnecting = false;

  bool get isConnected => _isConnected;

  Future<Stream<dynamic>?> connect() async {
    if (_isConnected) return _controller?.stream;
    if (_isReconnecting) return null;

    // Проверяем подключение перед установкой WebSocket
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      throw ForexException.fromType(ErrorType.network);
    }

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$baseUrl?token=$apiToken'),
      );

      _controller = StreamController<dynamic>.broadcast();

      // Слушаем сообщения
      _channel?.stream.listen(
        (data) {
          final controller = _controller;
          if (controller != null && !controller.isClosed) {
            controller.add(data);
          }
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _reconnect();
        },
        onDone: () {
          print('WebSocket Connection Closed');
          _reconnect();
        },
      );

      _isConnected = true;
      _startPingTimer();

      return _controller?.stream;
    } catch (e) {
      _isConnected = false;
      throw ForexException.fromType(ErrorType.network, e);
    }
  }

  void send(String message) {
    if (_isConnected && _channel != null) {
      try {
        _channel?.sink.add(message);
      } catch (e) {
        print('WebSocket Send Error: $e');
        _reconnect();
      }
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      send('{"type":"ping"}');
    });
  }

  void _reconnect() {
    if (_isReconnecting) return;

    _isReconnecting = true;
    disconnect();

    Future.delayed(Duration(seconds: 5), () async {
      _isReconnecting = false;

      try {
        await connect();
      } catch (e) {
        // Игнорируем ошибки при переподключении
      }
    });
  }

  void disconnect() {
    _isConnected = false;
    _pingTimer?.cancel();
    _channel?.sink.close();
    _controller?.close();
    _channel = null;
    _controller = null;
  }

  void dispose() {
    disconnect();
    _pingTimer?.cancel();
  }
}
