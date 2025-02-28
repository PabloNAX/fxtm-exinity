// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forex_update_ws_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForexUpdateWsModel _$ForexUpdateWsModelFromJson(Map<String, dynamic> json) {
  return _ForexUpdateWsModel.fromJson(json);
}

/// @nodoc
mixin _$ForexUpdateWsModel {
  String get type => throw _privateConstructorUsedError;
  List<ForexUpdateData> get data => throw _privateConstructorUsedError;

  /// Serializes this ForexUpdateWsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForexUpdateWsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForexUpdateWsModelCopyWith<ForexUpdateWsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForexUpdateWsModelCopyWith<$Res> {
  factory $ForexUpdateWsModelCopyWith(
          ForexUpdateWsModel value, $Res Function(ForexUpdateWsModel) then) =
      _$ForexUpdateWsModelCopyWithImpl<$Res, ForexUpdateWsModel>;
  @useResult
  $Res call({String type, List<ForexUpdateData> data});
}

/// @nodoc
class _$ForexUpdateWsModelCopyWithImpl<$Res, $Val extends ForexUpdateWsModel>
    implements $ForexUpdateWsModelCopyWith<$Res> {
  _$ForexUpdateWsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForexUpdateWsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ForexUpdateData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForexUpdateWsModelImplCopyWith<$Res>
    implements $ForexUpdateWsModelCopyWith<$Res> {
  factory _$$ForexUpdateWsModelImplCopyWith(_$ForexUpdateWsModelImpl value,
          $Res Function(_$ForexUpdateWsModelImpl) then) =
      __$$ForexUpdateWsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, List<ForexUpdateData> data});
}

/// @nodoc
class __$$ForexUpdateWsModelImplCopyWithImpl<$Res>
    extends _$ForexUpdateWsModelCopyWithImpl<$Res, _$ForexUpdateWsModelImpl>
    implements _$$ForexUpdateWsModelImplCopyWith<$Res> {
  __$$ForexUpdateWsModelImplCopyWithImpl(_$ForexUpdateWsModelImpl _value,
      $Res Function(_$ForexUpdateWsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForexUpdateWsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = null,
  }) {
    return _then(_$ForexUpdateWsModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ForexUpdateData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForexUpdateWsModelImpl implements _ForexUpdateWsModel {
  const _$ForexUpdateWsModelImpl(
      {required this.type, required final List<ForexUpdateData> data})
      : _data = data;

  factory _$ForexUpdateWsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForexUpdateWsModelImplFromJson(json);

  @override
  final String type;
  final List<ForexUpdateData> _data;
  @override
  List<ForexUpdateData> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'ForexUpdateWsModel(type: $type, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForexUpdateWsModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(_data));

  /// Create a copy of ForexUpdateWsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForexUpdateWsModelImplCopyWith<_$ForexUpdateWsModelImpl> get copyWith =>
      __$$ForexUpdateWsModelImplCopyWithImpl<_$ForexUpdateWsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForexUpdateWsModelImplToJson(
      this,
    );
  }
}

abstract class _ForexUpdateWsModel implements ForexUpdateWsModel {
  const factory _ForexUpdateWsModel(
      {required final String type,
      required final List<ForexUpdateData> data}) = _$ForexUpdateWsModelImpl;

  factory _ForexUpdateWsModel.fromJson(Map<String, dynamic> json) =
      _$ForexUpdateWsModelImpl.fromJson;

  @override
  String get type;
  @override
  List<ForexUpdateData> get data;

  /// Create a copy of ForexUpdateWsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForexUpdateWsModelImplCopyWith<_$ForexUpdateWsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ForexUpdateData _$ForexUpdateDataFromJson(Map<String, dynamic> json) {
  return _ForexUpdateData.fromJson(json);
}

/// @nodoc
mixin _$ForexUpdateData {
  @JsonKey(name: 's')
  String get symbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'p')
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 't')
  int get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'v')
  double get volume => throw _privateConstructorUsedError;

  /// Serializes this ForexUpdateData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForexUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForexUpdateDataCopyWith<ForexUpdateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForexUpdateDataCopyWith<$Res> {
  factory $ForexUpdateDataCopyWith(
          ForexUpdateData value, $Res Function(ForexUpdateData) then) =
      _$ForexUpdateDataCopyWithImpl<$Res, ForexUpdateData>;
  @useResult
  $Res call(
      {@JsonKey(name: 's') String symbol,
      @JsonKey(name: 'p') double price,
      @JsonKey(name: 't') int timestamp,
      @JsonKey(name: 'v') double volume});
}

/// @nodoc
class _$ForexUpdateDataCopyWithImpl<$Res, $Val extends ForexUpdateData>
    implements $ForexUpdateDataCopyWith<$Res> {
  _$ForexUpdateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForexUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? price = null,
    Object? timestamp = null,
    Object? volume = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForexUpdateDataImplCopyWith<$Res>
    implements $ForexUpdateDataCopyWith<$Res> {
  factory _$$ForexUpdateDataImplCopyWith(_$ForexUpdateDataImpl value,
          $Res Function(_$ForexUpdateDataImpl) then) =
      __$$ForexUpdateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 's') String symbol,
      @JsonKey(name: 'p') double price,
      @JsonKey(name: 't') int timestamp,
      @JsonKey(name: 'v') double volume});
}

/// @nodoc
class __$$ForexUpdateDataImplCopyWithImpl<$Res>
    extends _$ForexUpdateDataCopyWithImpl<$Res, _$ForexUpdateDataImpl>
    implements _$$ForexUpdateDataImplCopyWith<$Res> {
  __$$ForexUpdateDataImplCopyWithImpl(
      _$ForexUpdateDataImpl _value, $Res Function(_$ForexUpdateDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForexUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? price = null,
    Object? timestamp = null,
    Object? volume = null,
  }) {
    return _then(_$ForexUpdateDataImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForexUpdateDataImpl implements _ForexUpdateData {
  const _$ForexUpdateDataImpl(
      {@JsonKey(name: 's') required this.symbol,
      @JsonKey(name: 'p') required this.price,
      @JsonKey(name: 't') required this.timestamp,
      @JsonKey(name: 'v') required this.volume});

  factory _$ForexUpdateDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForexUpdateDataImplFromJson(json);

  @override
  @JsonKey(name: 's')
  final String symbol;
  @override
  @JsonKey(name: 'p')
  final double price;
  @override
  @JsonKey(name: 't')
  final int timestamp;
  @override
  @JsonKey(name: 'v')
  final double volume;

  @override
  String toString() {
    return 'ForexUpdateData(symbol: $symbol, price: $price, timestamp: $timestamp, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForexUpdateDataImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, symbol, price, timestamp, volume);

  /// Create a copy of ForexUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForexUpdateDataImplCopyWith<_$ForexUpdateDataImpl> get copyWith =>
      __$$ForexUpdateDataImplCopyWithImpl<_$ForexUpdateDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForexUpdateDataImplToJson(
      this,
    );
  }
}

abstract class _ForexUpdateData implements ForexUpdateData {
  const factory _ForexUpdateData(
          {@JsonKey(name: 's') required final String symbol,
          @JsonKey(name: 'p') required final double price,
          @JsonKey(name: 't') required final int timestamp,
          @JsonKey(name: 'v') required final double volume}) =
      _$ForexUpdateDataImpl;

  factory _ForexUpdateData.fromJson(Map<String, dynamic> json) =
      _$ForexUpdateDataImpl.fromJson;

  @override
  @JsonKey(name: 's')
  String get symbol;
  @override
  @JsonKey(name: 'p')
  double get price;
  @override
  @JsonKey(name: 't')
  int get timestamp;
  @override
  @JsonKey(name: 'v')
  double get volume;

  /// Create a copy of ForexUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForexUpdateDataImplCopyWith<_$ForexUpdateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
