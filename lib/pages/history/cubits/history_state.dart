// lib/src/history/cubits/history_state.dart

import 'package:equatable/equatable.dart';
import '../../../data/models/candle_data.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<CandleData> data;

  HistoryLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class HistoryError extends HistoryState {
  final dynamic error;

  HistoryError(this.error);

  @override
  List<Object> get props => [error];
}
