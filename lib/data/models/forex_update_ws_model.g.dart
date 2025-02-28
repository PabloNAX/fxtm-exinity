// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forex_update_ws_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForexUpdateWsModelImpl _$$ForexUpdateWsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ForexUpdateWsModelImpl(
      type: json['type'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => ForexUpdateData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ForexUpdateWsModelImplToJson(
        _$ForexUpdateWsModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };

_$ForexUpdateDataImpl _$$ForexUpdateDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ForexUpdateDataImpl(
      symbol: json['s'] as String,
      price: (json['p'] as num).toDouble(),
      timestamp: (json['t'] as num).toInt(),
      volume: (json['v'] as num).toDouble(),
    );

Map<String, dynamic> _$$ForexUpdateDataImplToJson(
        _$ForexUpdateDataImpl instance) =>
    <String, dynamic>{
      's': instance.symbol,
      'p': instance.price,
      't': instance.timestamp,
      'v': instance.volume,
    };
