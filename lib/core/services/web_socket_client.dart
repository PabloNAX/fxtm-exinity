import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

class WebSocketClient {
  final String apiToken;
  static const String baseUrl = 'wss://ws.finnhub.io';

  WebSocketClient({required this.apiToken});

  WebSocketChannel? _channel;
  StreamController<dynamic>? _controller;
  Timer? _pingTimer;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Stream<dynamic>? connect() {
    if (_isConnected) return _controller?.stream;

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$baseUrl?token=$apiToken'),
      );

      _controller = StreamController<dynamic>.broadcast();

      // Слушаем входящие сообщения
      _channel?.stream.listen(
        (data) {
// After (fixed):
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
      print('WebSocket Connection Error: $e');
      _reconnect();
      return null;
    }
  }

  void send(String message) {
    if (_isConnected && _channel != null) {
      _channel?.sink.add(message);
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      send('{"type":"ping"}');
    });
  }

  void _reconnect() {
    disconnect();
    Future.delayed(Duration(seconds: 5), () {
      connect();
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
    _controller?.close();
  }
}
