// lib/src/history/cubits/history_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/exceptions/app_error.dart';
import '../../../core/services/error_service.dart';
import '../../../data/models/candle_data.dart';
import '../../../data/repositories/forex_repository.dart';
import 'history_state.dart';

/// Cubit for managing the state of historical forex data, including loading data and handling errors.
class HistoryCubit extends Cubit<HistoryState> {
  final ForexRepository _forexRepository;

  HistoryCubit(this._forexRepository) : super(HistoryInitial());

  Future<void> loadHistoricalData(
    String symbol, {
    String resolution = 'D',
    required int from,
    required int to,
  }) async {
    // Get previous data if available
    List<CandleData>? previousData;
    if (state is HistoryLoaded) {
      previousData = (state as HistoryLoaded).data;
    }

    emit(HistoryLoading(previousData: previousData));

    try {
      final historicalData = await _forexRepository.getHistoricalData(
        symbol,
        resolution: resolution,
        from: from,
        to: to,
      );

      if (historicalData.isEmpty) {
        emit(HistoryError(
          AppError(
            message: 'No data available for the selected period',
            type: ErrorType.data,
          ),
        ));
        return;
      }

      emit(HistoryLoaded(historicalData));
    } catch (e) {
      final appError = ErrorService.handleError(e);
      emit(HistoryError(appError));
    }
  }
}
