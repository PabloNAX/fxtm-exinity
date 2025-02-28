// lib/data/models/candle_data_api_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'candle_data_api_model.freezed.dart';
part 'candle_data_api_model.g.dart';

@freezed
class CandleDataApiModel with _$CandleDataApiModel {
  const factory CandleDataApiModel({
    required List<double> o, // open prices
    required List<double> h, // high prices
    required List<double> l, // low prices
    required List<double> c, // close prices
    required List<int> t, // timestamps
    required List<int> v, // volumes
    required String s, // status
  }) = _CandleDataApiModel;

  factory CandleDataApiModel.fromJson(Map<String, dynamic> json) =>
      _$CandleDataApiModelFromJson(json);
}
