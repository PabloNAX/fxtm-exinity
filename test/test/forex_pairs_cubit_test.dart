import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fxtm/core/exceptions/forex_exception.dart';
import 'package:fxtm/pages/forex_list/cubits/forex_pairs_cubit.dart';
import 'package:fxtm/pages/forex_list/cubits/forex_pairs_state.dart';
import 'package:fxtm/mocks/data/mock_data.dart';
import 'mock_classes.mocks.dart';

void main() {
  late MockForexRepository mockRepository;
  late MockWsService mockWsService;
  late ForexPairsCubit cubit;

  setUp(() {
    mockRepository = MockForexRepository();
    mockWsService = MockWsService();
    cubit = ForexPairsCubit(mockWsService, mockRepository);
  });

  tearDown(() {});

  test('initial state is ForexPairsInitial', () {
    expect(cubit.state, isA<ForexPairsInitial>());
    cubit.close();
  });

  blocTest<ForexPairsCubit, ForexPairsState>(
    'emits [ForexPairsLoading, ForexPairsLoaded] when loadForexPairs is called successfully',
    build: () {
      final mockPairs = MockData.getInitialForexPairs();
      when(mockRepository.getForexPairs()).thenAnswer((_) async => mockPairs);
      when(mockWsService.subscribeToSymbols(any, any)).thenAnswer((_) async {});
      return cubit;
    },
    act: (cubit) => cubit.loadForexPairs(),
    expect: () => [
      isA<ForexPairsLoading>(),
      isA<ForexPairsLoaded>(),
    ],
    verify: (_) {
      verify(mockRepository.getForexPairs()).called(1);
      verify(mockWsService.subscribeToSymbols(any, any)).called(1);
    },
  );

  blocTest<ForexPairsCubit, ForexPairsState>(
    'emits [ForexPairsLoading, ForexPairsError] when loadForexPairs fails',
    build: () {
      when(mockRepository.getForexPairs()).thenThrow(
        ForexException('Error loading forex pairs', type: ErrorType.network),
      );
      return cubit;
    },
    act: (cubit) => cubit.loadForexPairs(),
    expect: () => [
      isA<ForexPairsLoading>(),
      isA<ForexPairsError>(),
    ],
    verify: (_) {
      verify(mockRepository.getForexPairs()).called(1);
      verifyNever(mockWsService.subscribeToSymbols(any, any));
    },
  );

  // Тест для pauseWebSocket
  blocTest<ForexPairsCubit, ForexPairsState>(
    'pauseWebSocket should unsubscribe from WebSocket',
    build: () {
      // Подготавливаем кубит
      final mockPairs = MockData.getInitialForexPairs();

      // Мокируем необходимые методы
      when(mockRepository.getForexPairs()).thenAnswer((_) async => mockPairs);
      when(mockWsService.subscribeToSymbols(any, any)).thenAnswer((_) async {});
      when(mockWsService.unsubscribeFromAll()).thenAnswer((_) async {});

      // Создаем кубит и загружаем данные, чтобы установить WebSocket в connected
      cubit.loadForexPairs();

      // Ждем, пока loadForexPairs завершится
      return cubit;
    },
    act: (cubit) async {
      // Очищаем предыдущие взаимодействия перед тестом
      clearInteractions(mockWsService);

      // Вызываем метод, который тестируем
      await cubit.pauseWebSocket();
    },
    expect: () => anything, // Игнорируем эмитированные состояния
    verify: (cubit) {
      // Проверяем, что метод unsubscribeFromAll был вызван
      verify(mockWsService.unsubscribeFromAll()).called(1);
    },
  );

  // Тест для resumeWebSocket
  blocTest<ForexPairsCubit, ForexPairsState>(
    'resumeWebSocket should resubscribe to WebSocket',
    build: () {
      // Подготавливаем кубит
      final mockPairs = MockData.getInitialForexPairs();

      // Мокируем необходимые методы
      when(mockRepository.getForexPairs()).thenAnswer((_) async => mockPairs);
      when(mockWsService.subscribeToSymbols(any, any)).thenAnswer((_) async {});
      when(mockWsService.unsubscribeFromAll()).thenAnswer((_) async {});

      // Создаем кубит и загружаем данные
      cubit.loadForexPairs();

      // Вызываем pauseWebSocket, чтобы установить WebSocket в paused
      cubit.pauseWebSocket();

      // Очищаем предыдущие взаимодействия
      clearInteractions(mockWsService);

      return cubit;
    },
    act: (cubit) async {
      // Вызываем метод, который тестируем
      await cubit.resumeWebSocket();
    },
    expect: () => anything, // Игнорируем эмитированные состояния
    verify: (cubit) {
      // Проверяем, что метод subscribeToSymbols был вызван
      verify(mockWsService.subscribeToSymbols(any, any)).called(1);
    },
  );
}
