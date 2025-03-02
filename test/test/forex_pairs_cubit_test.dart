import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm/core/exceptions/app_error.dart';
import 'package:mockito/mockito.dart';
import 'package:fxtm/pages/forex_list/cubits/forex_pairs_cubit.dart';
import 'package:fxtm/pages/forex_list/cubits/forex_pairs_state.dart';
import 'package:fxtm/mocks/data/mock_data.dart';
import 'mock_classes.mocks.dart';

/// Unit tests for the ForexPairsCubit, which manages the state of forex pairs, including loading data and handling WebSocket subscriptions.
/// These tests ensure that the cubit correctly emits states based on the success or failure of data loading and WebSocket operations.
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
        AppError(message: 'Error loading forex pairs', type: ErrorType.network),
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

  // Test for pauseWebSocket
  blocTest<ForexPairsCubit, ForexPairsState>(
    'pauseWebSocket should unsubscribe from WebSocket',
    build: () {
      // Prepare the cubit
      final mockPairs = MockData.getInitialForexPairs();

      // Mock necessary methods
      when(mockRepository.getForexPairs()).thenAnswer((_) async => mockPairs);
      when(mockWsService.subscribeToSymbols(any, any)).thenAnswer((_) async {});
      when(mockWsService.unsubscribeFromAll()).thenAnswer((_) async {});

      // Create cubit and load data to set WebSocket to connected
      cubit.loadForexPairs();

      // Wait for loadForexPairs to complete
      return cubit;
    },
    act: (cubit) async {
      // Clear previous interactions before the test
      clearInteractions(mockWsService);

      // Call the method we are testing
      await cubit.pauseWebSocket();
    },
    expect: () => anything, // Ignore emitted states
    verify: (cubit) {
      // Verify that the unsubscribeFromAll method was called
      verify(mockWsService.unsubscribeFromAll()).called(1);
    },
  );

  // Test for resumeWebSocket
  blocTest<ForexPairsCubit, ForexPairsState>(
    'resumeWebSocket should resubscribe to WebSocket',
    build: () {
      // Prepare the cubit
      final mockPairs = MockData.getInitialForexPairs();

      // Mock necessary methods
      when(mockRepository.getForexPairs()).thenAnswer((_) async => mockPairs);
      when(mockWsService.subscribeToSymbols(any, any)).thenAnswer((_) async {});
      when(mockWsService.unsubscribeFromAll()).thenAnswer((_) async {});

      // Create cubit and load data
      cubit.loadForexPairs();

      // Call pauseWebSocket to set WebSocket to paused
      cubit.pauseWebSocket();

      // Clear previous interactions
      clearInteractions(mockWsService);

      return cubit;
    },
    act: (cubit) async {
      // Call the method we are testing
      await cubit.resumeWebSocket();
    },
    expect: () => anything, // Ignore emitted states
    verify: (cubit) {
      // Verify that the subscribeToSymbols method was called
      verify(mockWsService.subscribeToSymbols(any, any)).called(1);
    },
  );
}
