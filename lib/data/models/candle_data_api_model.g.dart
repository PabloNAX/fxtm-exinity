// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candle_data_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CandleDataApiModelImpl _$$CandleDataApiModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CandleDataApiModelImpl(
      o: (json['o'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      h: (json['h'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      l: (json['l'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      c: (json['c'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      t: (json['t'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      v: (json['v'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      s: json['s'] as String,
    );

Map<String, dynamic> _$$CandleDataApiModelImplToJson(
        _$CandleDataApiModelImpl instance) =>
    <String, dynamic>{
      'o': instance.o,
      'h': instance.h,
      'l': instance.l,
      'c': instance.c,
      't': instance.t,
      'v': instance.v,
      's': instance.s,
    };
