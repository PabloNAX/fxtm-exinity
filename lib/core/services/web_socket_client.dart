// lib/core/services/web_socket_client.dart

import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import '../exceptions/app_error.dart';
import 'connectivity_service.dart';

/// Client for managing WebSocket connections and handling messages.
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
    if (_isConnected) {
      print('Already connected to WebSocket.');
      return _controller?.stream;
    }
    if (_isReconnecting) {
      print('Attempting to reconnect to WebSocket...');
      return null;
    }

    // Check connectivity before establishing WebSocket
    final hasConnection = await _connectivityService.hasConnection();
    if (!hasConnection) {
      print('No internet connection. Cannot connect to WebSocket.');
      throw AppError.network();
    }

    print('Connecting to WebSocket...');
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$baseUrl?token=$apiToken'),
      );

      _controller = StreamController<dynamic>.broadcast();

      // Listen for messages
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
      print('Successfully connected to WebSocket.');
      _startPingTimer();

      return _controller?.stream;
    } catch (e) {
      _isConnected = false;
      print('Failed to connect to WebSocket: $e');
      throw AppError.network(e);
    }
  }

  void send(String message) {
    if (_isConnected && _channel != null) {
      try {
        _channel?.sink.add(message);
        print('Sent message: $message');
      } catch (e) {
        print('WebSocket Send Error: $e');
        _reconnect();
      }
    } else {
      print('Cannot send message, WebSocket is not connected.');
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      send('{"type":"ping"}');
      print('Sent ping to WebSocket.');
    });
  }

  void _reconnect() {
    if (_isReconnecting) {
      print('Already attempting to reconnect to WebSocket.');
      return;
    }

    _isReconnecting = true;
    print('Disconnecting from WebSocket to attempt reconnection...');
    disconnect();

    Future.delayed(const Duration(seconds: 5), () async {
      _isReconnecting = false;
      print('Attempting to reconnect to WebSocket...');
      try {
        await connect();
      } catch (e) {
        print('Reconnection attempt failed: $e');
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
    print('Disconnected from WebSocket.');
  }

  void dispose() {
    disconnect();
    _pingTimer?.cancel();
  }
}
