// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forex_symbols_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForexSymbolsApiModel _$ForexSymbolsApiModelFromJson(Map<String, dynamic> json) {
  return _ForexSymbolsApiModel.fromJson(json);
}

/// @nodoc
mixin _$ForexSymbolsApiModel {
  String? get description => throw _privateConstructorUsedError;
  String? get displaySymbol => throw _privateConstructorUsedError;
  String? get symbol => throw _privateConstructorUsedError;

  /// Serializes this ForexSymbolsApiModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForexSymbolsApiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForexSymbolsApiModelCopyWith<ForexSymbolsApiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForexSymbolsApiModelCopyWith<$Res> {
  factory $ForexSymbolsApiModelCopyWith(ForexSymbolsApiModel value,
          $Res Function(ForexSymbolsApiModel) then) =
      _$ForexSymbolsApiModelCopyWithImpl<$Res, ForexSymbolsApiModel>;
  @useResult
  $Res call({String? description, String? displaySymbol, String? symbol});
}

/// @nodoc
class _$ForexSymbolsApiModelCopyWithImpl<$Res,
        $Val extends ForexSymbolsApiModel>
    implements $ForexSymbolsApiModelCopyWith<$Res> {
  _$ForexSymbolsApiModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForexSymbolsApiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? displaySymbol = freezed,
    Object? symbol = freezed,
  }) {
    return _then(_value.copyWith(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      displaySymbol: freezed == displaySymbol
          ? _value.displaySymbol
          : displaySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForexSymbolsApiModelImplCopyWith<$Res>
    implements $ForexSymbolsApiModelCopyWith<$Res> {
  factory _$$ForexSymbolsApiModelImplCopyWith(_$ForexSymbolsApiModelImpl value,
          $Res Function(_$ForexSymbolsApiModelImpl) then) =
      __$$ForexSymbolsApiModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? description, String? displaySymbol, String? symbol});
}

/// @nodoc
class __$$ForexSymbolsApiModelImplCopyWithImpl<$Res>
    extends _$ForexSymbolsApiModelCopyWithImpl<$Res, _$ForexSymbolsApiModelImpl>
    implements _$$ForexSymbolsApiModelImplCopyWith<$Res> {
  __$$ForexSymbolsApiModelImplCopyWithImpl(_$ForexSymbolsApiModelImpl _value,
      $Res Function(_$ForexSymbolsApiModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForexSymbolsApiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? displaySymbol = freezed,
    Object? symbol = freezed,
  }) {
    return _then(_$ForexSymbolsApiModelImpl(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      displaySymbol: freezed == displaySymbol
          ? _value.displaySymbol
          : displaySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForexSymbolsApiModelImpl implements _ForexSymbolsApiModel {
  const _$ForexSymbolsApiModelImpl(
      {required this.description,
      required this.displaySymbol,
      required this.symbol});

  factory _$ForexSymbolsApiModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForexSymbolsApiModelImplFromJson(json);

  @override
  final String? description;
  @override
  final String? displaySymbol;
  @override
  final String? symbol;

  @override
  String toString() {
    return 'ForexSymbolsApiModel(description: $description, displaySymbol: $displaySymbol, symbol: $symbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForexSymbolsApiModelImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.displaySymbol, displaySymbol) ||
                other.displaySymbol == displaySymbol) &&
            (identical(other.symbol, symbol) || other.symbol == symbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, description, displaySymbol, symbol);

  /// Create a copy of ForexSymbolsApiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForexSymbolsApiModelImplCopyWith<_$ForexSymbolsApiModelImpl>
      get copyWith =>
          __$$ForexSymbolsApiModelImplCopyWithImpl<_$ForexSymbolsApiModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForexSymbolsApiModelImplToJson(
      this,
    );
  }
}

abstract class _ForexSymbolsApiModel implements ForexSymbolsApiModel {
  const factory _ForexSymbolsApiModel(
      {required final String? description,
      required final String? displaySymbol,
      required final String? symbol}) = _$ForexSymbolsApiModelImpl;

  factory _ForexSymbolsApiModel.fromJson(Map<String, dynamic> json) =
      _$ForexSymbolsApiModelImpl.fromJson;

  @override
  String? get description;
  @override
  String? get displaySymbol;
  @override
  String? get symbol;

  /// Create a copy of ForexSymbolsApiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForexSymbolsApiModelImplCopyWith<_$ForexSymbolsApiModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
