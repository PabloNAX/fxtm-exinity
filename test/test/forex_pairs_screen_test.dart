import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fxtm/pages/forex_list/forex_pairs_screen.dart';

import 'mock_classes.mocks.dart';

void main() {
  late MockForexRepository mockRepository;
  late MockWsService mockWsService;

  setUp(() {
    mockRepository = MockForexRepository();
    mockWsService = MockWsService();

    // Настраиваем моки для синхронного ответа
    when(mockRepository.getForexPairs()).thenAnswer((_) async => []);
    when(mockWsService.subscribeToSymbols(any, any)).thenAnswer((_) async {});
  });

  // Вспомогательная функция для создания тестового виджета
  Widget createTestWidget() {
    return MaterialApp(
      home: ForexPairsScreen(
        forexRepository: mockRepository,
        wsService: mockWsService,
      ),
    );
  }

  testWidgets('ForexPairsScreen renders without crashing',
      (WidgetTester tester) async {
    // Рендерим виджет
    await tester.pumpWidget(createTestWidget());

    // Проверяем, что виджет отрендерился без ошибок
    expect(find.byType(ForexPairsScreen), findsOneWidget);
  });

  testWidgets('ForexPairsScreen shows CircularProgressIndicator initially',
      (WidgetTester tester) async {
    // Рендерим виджет
    await tester.pumpWidget(createTestWidget());

    // Проверяем, что отображается индикатор загрузки
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
