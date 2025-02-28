import 'package:equatable/equatable.dart';
import '../../../data/models/candle_data.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<CandleData> data; // Изменено на List<CandleData>

  HistoryLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
