// lib/src/forex_pairs/cubits/forex_pairs_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/ws_service.dart';
import '../../../data/models/forex_pair.dart';
import '../../../data/repositories/forex_repository.dart';
import 'forex_pairs_state.dart';

class ForexPairsCubit extends Cubit<ForexPairsState> {
  final ForexRepository _repository;
  final WsService _wsService;
  List<String>? _lastSubscribedSymbols; // Сохраняем список символов

  ForexPairsCubit(this._wsService, this._repository)
      : super(ForexPairsInitial());

  // Метод для временной приостановки WebSocket
  Future<void> pauseWebSocket() async {
    if (state is ForexPairsLoaded) {
      final currentState = state as ForexPairsLoaded;
      _lastSubscribedSymbols = currentState.pairs.map((p) => p.symbol).toList();
      _wsService.unsubscribeFromAll();
    }
  }

  // Метод для возобновления WebSocket
  Future<void> resumeWebSocket() async {
    if (_lastSubscribedSymbols != null && state is ForexPairsLoaded) {
      _wsService.subscribeToSymbols(
        _lastSubscribedSymbols!,
        _handlePriceUpdate,
      );
    }
  }

  @override
  Future<void> close() {
    _wsService.unsubscribeFromAll();
    _lastSubscribedSymbols = null;
    return super.close();
  }

  Future<void> loadForexPairs() async {
    emit(ForexPairsLoading());

    try {
      final pairs = await _repository.getForexPairs();
      emit(ForexPairsLoaded(pairs));

      // Подписываемся на обновления через WebSocket
      _wsService.subscribeToSymbols(
        pairs.map((p) => p.symbol).toList(),
        _handlePriceUpdate,
      );
    } catch (e) {
      emit(ForexPairsError(e.toString()));
    }
  }

  void _handlePriceUpdate(ForexPair updatedPair) {
    if (state is ForexPairsLoaded) {
      final currentState = state as ForexPairsLoaded;
      final updatedPairs = currentState.pairs.map((pair) {
        if (pair.symbol == updatedPair.symbol) {
          return updatedPair;
        }
        return pair;
      }).toList();

      emit(ForexPairsLoaded(updatedPairs));
    }
  }
}
