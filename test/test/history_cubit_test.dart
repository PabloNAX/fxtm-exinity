// test/unit/features/history/cubits/history_cubit_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fxtm/core/exceptions/forex_exception.dart';
import 'package:fxtm/pages/history/cubits/history_cubit.dart';
import 'package:fxtm/pages/history/cubits/history_state.dart';
import 'package:fxtm/mocks/data/mock_data.dart';
import 'package:fxtm/data/models/candle_data.dart';

import 'mock_classes.mocks.dart';

void main() {
  late MockForexRepository mockRepository;
  late HistoryCubit cubit;

  setUp(() {
    mockRepository = MockForexRepository();
    cubit = HistoryCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is HistoryInitial', () {
    expect(cubit.state, isA<HistoryInitial>());
  });

  blocTest<HistoryCubit, HistoryState>(
    'emits [HistoryLoading, HistoryLoaded] when loadHistoricalData is called successfully',
    build: () {
      // Convert CandleDataApiModel to List<CandleData>
      final apiModel = MockData.getHistoricalData('OANDA:EUR_USD');
      final candleDataList = List<CandleData>.generate(
        apiModel.c.length,
        (i) => CandleData(
          open: apiModel.o[i],
          high: apiModel.h[i],
          low: apiModel.l[i],
          close: apiModel.c[i],
          timestamp: apiModel.t[i],
          volume: apiModel.v[i],
        ),
      );

      when(mockRepository.getHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).thenAnswer((_) async => candleDataList);

      return cubit;
    },
    act: (cubit) => cubit.loadHistoricalData(
      'OANDA:EUR_USD',
      resolution: 'D',
      from: 1646092800,
      to: 1646265600,
    ),
    expect: () => [
      isA<HistoryLoading>(),
      isA<HistoryLoaded>(),
    ],
    verify: (_) {
      verify(mockRepository.getHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).called(1);
    },
  );

  blocTest<HistoryCubit, HistoryState>(
    'emits [HistoryLoading, HistoryError] when loadHistoricalData fails',
    build: () {
      when(mockRepository.getHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).thenThrow(
        ForexException('Error loading historical data',
            type: ErrorType.network),
      );
      return cubit;
    },
    act: (cubit) => cubit.loadHistoricalData(
      'OANDA:EUR_USD',
      resolution: 'D',
      from: 1646092800,
      to: 1646265600,
    ),
    expect: () => [
      isA<HistoryLoading>(),
      isA<HistoryError>(),
    ],
    verify: (_) {
      verify(mockRepository.getHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).called(1);
    },
  );

  blocTest<HistoryCubit, HistoryState>(
    'emits [HistoryLoading, HistoryError] when loadHistoricalData returns empty data',
    build: () {
      when(mockRepository.getHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).thenAnswer((_) async => []);
      return cubit;
    },
    act: (cubit) => cubit.loadHistoricalData(
      'OANDA:EUR_USD',
      resolution: 'D',
      from: 1646092800,
      to: 1646265600,
    ),
    expect: () => [
      isA<HistoryLoading>(),
      isA<HistoryError>(),
    ],
    verify: (_) {
      verify(mockRepository.getHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).called(1);
    },
  );
}
