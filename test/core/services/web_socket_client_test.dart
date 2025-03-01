import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm/core/services/connectivity_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fxtm/core/services/web_socket_client.dart';
import 'dart:async';

// Создаем моки
class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  group('WebSocketClient', () {
    late WebSocketClient webSocketClient;
    late ConnectivityService connectivityService;
    const String testApiToken = 'test_token';

    setUp(() {
      webSocketClient = WebSocketClient(
          apiToken: testApiToken, connectivityService: connectivityService);
    });

    test('connect should initialize connection', () {
      // Проверяем начальное состояние
      expect(webSocketClient.isConnected, false);

      // Вызываем connect и проверяем, что он возвращает Stream
      final stream = webSocketClient.connect();
      expect(stream, isA<Stream<dynamic>?>());
    });

    test('disconnect should set isConnected to false', () {
      // Сначала подключаемся
      webSocketClient.connect();

      // Затем отключаемся
      webSocketClient.disconnect();

      // Проверяем, что isConnected стало false
      expect(webSocketClient.isConnected, false);
    });

    test('send should not throw when not connected', () {
      // Проверяем, что отправка сообщения не вызывает ошибок, даже если не подключены
      expect(() => webSocketClient.send('{"type":"test"}'), returnsNormally);
    });
  });
}
