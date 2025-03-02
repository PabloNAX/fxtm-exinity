// lib/src/forex_pairs/cubits/forex_pairs_state.dart

import 'package:equatable/equatable.dart';
import '../../../data/models/forex_pair.dart';

abstract class ForexPairsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForexPairsInitial extends ForexPairsState {}

class ForexPairsLoading extends ForexPairsState {}

class ForexPairsLoaded extends ForexPairsState {
  final List<ForexPair> pairs;

  ForexPairsLoaded(this.pairs);

  @override
  List<Object> get props => [pairs];
}

class ForexPairsError extends ForexPairsState {
  final dynamic error;

  ForexPairsError(this.error);

  @override
  List<Object> get props => [error];
}
