import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/forex_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final ForexRepository _forexRepository;

  HistoryCubit(this._forexRepository) : super(HistoryInitial());

  Future<void> loadHistoricalData(String symbol,
      {String resolution = 'D'}) async {
    emit(HistoryLoading());

    try {
      final historicalData = await _forexRepository.getHistoricalData(symbol,
          resolution: resolution);
      emit(HistoryLoaded(historicalData)); // Теперь передаем List<CandleData>
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
