// lib/src/forex_pairs/cubits/forex_pairs_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/error_service.dart';
import '../../../core/services/ws_service.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/forex_pair.dart';
import '../../../data/repositories/forex_repository.dart';
import 'forex_pairs_state.dart';

/// Cubit for managing the state of forex pairs, handling loading, error states, and WebSocket subscriptions for real-time price updates.
class ForexPairsCubit extends Cubit<ForexPairsState> {
  final ForexRepository _repository;
  final WsService _wsService;
  List<String>? _lastSubscribedSymbols;
  WebSocketStatus _wsStatus = WebSocketStatus.disconnected;

  ForexPairsCubit(this._wsService, this._repository)
      : super(ForexPairsInitial());

  Future<void> pauseWebSocket() async {
    if (_wsStatus == WebSocketStatus.connected && state is ForexPairsLoaded) {
      final currentState = state as ForexPairsLoaded;
      _lastSubscribedSymbols = currentState.pairs.map((p) => p.symbol).toList();
      try {
        _wsService.unsubscribeFromAll();
        _wsStatus = WebSocketStatus.paused;
      } catch (e) {
        print('Error pausing WebSocket: $e');
      }
    }
  }

  Future<void> resumeWebSocket() async {
    if (_wsStatus == WebSocketStatus.paused &&
        _lastSubscribedSymbols != null &&
        state is ForexPairsLoaded) {
      try {
        _wsService.subscribeToSymbols(
          _lastSubscribedSymbols!,
          _handlePriceUpdate,
        );
        _wsStatus = WebSocketStatus.connected;
      } catch (e) {
        final appError = ErrorService.handleError(e);
        emit(ForexPairsError(appError));
      }
    }
  }

  @override
  Future<void> close() {
    try {
      // Only unsubscribe if we're connected or paused
      if (_wsStatus != WebSocketStatus.disconnected) {
        _wsService.unsubscribeFromAll();
        _wsStatus = WebSocketStatus.disconnected;
      }
    } catch (e) {
      print('Error closing WebSocket: $e');
    }
    return super.close();
  }

  Future<void> loadForexPairs() async {
    emit(ForexPairsLoading());

    try {
      final pairs = await _repository.getForexPairs();
      emit(ForexPairsLoaded(pairs));

      // Only subscribe if not already connected
      if (_wsStatus == WebSocketStatus.disconnected) {
        try {
          _wsService.subscribeToSymbols(
            pairs.map((p) => p.symbol).toList(),
            _handlePriceUpdate,
          );
          _wsStatus = WebSocketStatus.connected;
        } catch (e) {
          // WebSocket errors should not interrupt the application
          // Just log and continue
          print('WebSocket subscription error: $e');
          // Do not change the Cubit state since data has already been loaded
        }
      }
    } catch (e) {
      // Use ErrorService to convert the error to AppError
      final appError = ErrorService.handleError(e);
      emit(ForexPairsError(appError));
    }
  }

  void _handlePriceUpdate(ForexPair updatedPair) {
    // Do not update prices if WebSocket is paused
    if (_wsStatus == WebSocketStatus.paused) return;
    if (state is ForexPairsLoaded) {
      try {
        final currentState = state as ForexPairsLoaded;
        final updatedPairs = currentState.pairs.map((pair) {
          if (pair.symbol == updatedPair.symbol) {
            return updatedPair;
          }
          return pair;
        }).toList();

        emit(ForexPairsLoaded(updatedPairs));
      } catch (e) {
        // Just log the error but don't emit a state change for price updates
        print('Error updating price: $e');
      }
    }
  }
}
