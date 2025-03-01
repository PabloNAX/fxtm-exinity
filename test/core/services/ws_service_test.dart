import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fxtm/core/services/web_socket_client.dart';
import 'package:fxtm/core/services/ws_service.dart';
import 'package:fxtm/data/models/forex_pair.dart';
import 'dart:async';

// Создаем мок для WebSocketClient
class MockWebSocketClient extends Mock implements WebSocketClient {}

void main() {
  group('WsService', () {
    late WsService wsService;
    late MockWebSocketClient mockWebSocketClient;
    late StreamController<dynamic> streamController;

    setUp(() {
      mockWebSocketClient = MockWebSocketClient();
      streamController = StreamController<dynamic>.broadcast();

      // Настраиваем мок
      when(() => mockWebSocketClient.connect())
          .thenAnswer((_) => streamController.stream);

      when(() => mockWebSocketClient.send(any())).thenReturn(null);

      wsService = WsService(wsClient: mockWebSocketClient);

      // Используем registerFallbackValue для регистрации любого значения
      registerFallbackValue('any_message');
    });

    tearDown(() {
      streamController.close();
    });

    test('subscribeToSymbols should call connect on WebSocketClient', () {
      // Arrange
      final symbols = ['OANDA:EUR_USD'];
      final onPriceUpdate = (ForexPair pair) {};

      // Act
      wsService.subscribeToSymbols(symbols, onPriceUpdate);

      // Assert
      verify(() => mockWebSocketClient.connect()).called(1);
    });

    test('subscribeToSymbols should send subscribe message for each symbol',
        () {
      // Arrange
      final symbols = ['OANDA:EUR_USD', 'OANDA:GBP_USD'];
      final onPriceUpdate = (ForexPair pair) {};

      // Act
      wsService.subscribeToSymbols(symbols, onPriceUpdate);

      // Assert
      verify(() => mockWebSocketClient.send(any())).called(2);
    });

    test('should call onPriceUpdate when receiving trade data', () async {
      // Arrange
      final symbols = ['OANDA:EUR_USD'];
      final receivedPairs = <ForexPair>[];

      final onPriceUpdate = (ForexPair pair) {
        receivedPairs.add(pair);
      };

      // Act
      wsService.subscribeToSymbols(symbols, onPriceUpdate);

      // Имитируем получение сообщения от WebSocket
      final tradeMessage = jsonEncode({
        'type': 'trade',
        'data': [
          {
            'p': 1.1, // price
            's': 'OANDA:EUR_USD', // symbol
            't': 1625097600000, // timestamp
            'v': 1000 // volume
          }
        ]
      });

      streamController.add(tradeMessage);

      // Даем время на обработку сообщения
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      expect(receivedPairs.length, 1);
      expect(receivedPairs.first.symbol, 'OANDA:EUR_USD');
      expect(receivedPairs.first.currentPrice, 1.1);
    });

    test('unsubscribeFromAll should send unsubscribe message and disconnect',
        () {
      // Act
      wsService.unsubscribeFromAll();

      // Assert
      verify(() => mockWebSocketClient.send(any())).called(1);
      verify(() => mockWebSocketClient.disconnect()).called(1);
    });
  });
}
