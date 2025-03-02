import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fxtm/pages/forex_list/forex_pairs_screen.dart';

import 'mock_classes.mocks.dart';

/// Unit tests for the ForexPairsScreen widget, ensuring it renders correctly and displays loading indicators as expected.
/// These tests verify the integration of the screen with the mocked repository and WebSocket service.
void main() {
  late MockForexRepository mockRepository;
  late MockWsService mockWsService;

  setUp(() {
    mockRepository = MockForexRepository();
    mockWsService = MockWsService();

    // Set up mocks for synchronous responses
    when(mockRepository.getForexPairs()).thenAnswer((_) async => []);
    when(mockWsService.subscribeToSymbols(any, any)).thenAnswer((_) async {});
  });

  // Helper function to create the test widget
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
    // Render the widget
    await tester.pumpWidget(createTestWidget());

    // Verify that the widget renders without errors
    expect(find.byType(ForexPairsScreen), findsOneWidget);
  });

  testWidgets('ForexPairsScreen shows CircularProgressIndicator initially',
      (WidgetTester tester) async {
    // Render the widget
    await tester.pumpWidget(createTestWidget());

    // Verify that the loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
