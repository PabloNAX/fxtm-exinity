import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/forex_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final ForexRepository _forexRepository;

  HistoryCubit(this._forexRepository) : super(HistoryInitial());

  //TODO implement the right way to pass "from: from, to: to" params
  Future<void> loadHistoricalData(
    String symbol, {
    String resolution = 'D',
    from,
    to,
  }) async {
    emit(HistoryLoading());

    try {
      final historicalData = await _forexRepository.getHistoricalData(symbol,
          resolution: resolution, from: from, to: to);
      emit(HistoryLoaded(historicalData)); // Passing data List<CandleData>
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
