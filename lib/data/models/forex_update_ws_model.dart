import 'package:freezed_annotation/freezed_annotation.dart';

part 'forex_update_ws_model.freezed.dart';
part 'forex_update_ws_model.g.dart';

@freezed
class ForexUpdateWsModel with _$ForexUpdateWsModel {
  const factory ForexUpdateWsModel({
    required String type,
    required List<ForexUpdateData> data,
  }) = _ForexUpdateWsModel;

  factory ForexUpdateWsModel.fromJson(Map<String, dynamic> json) =>
      _$ForexUpdateWsModelFromJson(json);
}

@freezed
class ForexUpdateData with _$ForexUpdateData {
  const factory ForexUpdateData({
    @JsonKey(name: 's') required String symbol,
    @JsonKey(name: 'p') required double price,
    @JsonKey(name: 't') required int timestamp,
    @JsonKey(name: 'v') required double volume,
  }) = _ForexUpdateData;

  factory ForexUpdateData.fromJson(Map<String, dynamic> json) =>
      _$ForexUpdateDataFromJson(json);
}
