// lib/src/forex_pairs/cubits/forex_pairs_state.dart

import 'package:equatable/equatable.dart';
import '../../../data/models/forex_pair.dart';

// Базовый класс состояния
abstract class ForexPairsState extends Equatable {
  @override
  List<Object> get props => [];
}

// Начальное состояние
class ForexPairsInitial extends ForexPairsState {}

// Состояние загрузки
class ForexPairsLoading extends ForexPairsState {}

// Состояние, когда данные загружены
class ForexPairsLoaded extends ForexPairsState {
  final List<ForexPair> pairs;

  ForexPairsLoaded(this.pairs);

  @override
  List<Object> get props => [pairs];
}

// Состояние ошибки
class ForexPairsError extends ForexPairsState {
  final String message;

  ForexPairsError(this.message);

  @override
  List<Object> get props => [message];
}
