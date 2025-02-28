import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forex_symbols_api_model.freezed.dart';
part 'forex_symbols_api_model.g.dart';

@freezed
class ForexSymbolsApiModel with _$ForexSymbolsApiModel {
  const factory ForexSymbolsApiModel({
    required String? description,
    required String? displaySymbol,
    required String? symbol,
  }) = _ForexSymbolsApiModel;

  factory ForexSymbolsApiModel.fromJson(Map<String, dynamic> json) =>
      _$ForexSymbolsApiModelFromJson(json);
}
