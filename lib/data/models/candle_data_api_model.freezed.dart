// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candle_data_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CandleDataApiModel _$CandleDataApiModelFromJson(Map<String, dynamic> json) {
  return _CandleDataApiModel.fromJson(json);
}

/// @nodoc
mixin _$CandleDataApiModel {
  List<double> get o => throw _privateConstructorUsedError; // open prices
  List<double> get h => throw _privateConstructorUsedError; // high prices
  List<double> get l => throw _privateConstructorUsedError; // low prices
  List<double> get c => throw _privateConstructorUsedError; // close prices
  List<int> get t => throw _privateConstructorUsedError; // timestamps
  List<int> get v => throw _privateConstructorUsedError; // volumes
  String get s => throw _privateConstructorUsedError;

  /// Serializes this CandleDataApiModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CandleDataApiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandleDataApiModelCopyWith<CandleDataApiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandleDataApiModelCopyWith<$Res> {
  factory $CandleDataApiModelCopyWith(
          CandleDataApiModel value, $Res Function(CandleDataApiModel) then) =
      _$CandleDataApiModelCopyWithImpl<$Res, CandleDataApiModel>;
  @useResult
  $Res call(
      {List<double> o,
      List<double> h,
      List<double> l,
      List<double> c,
      List<int> t,
      List<int> v,
      String s});
}

/// @nodoc
class _$CandleDataApiModelCopyWithImpl<$Res, $Val extends CandleDataApiModel>
    implements $CandleDataApiModelCopyWith<$Res> {
  _$CandleDataApiModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandleDataApiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? o = null,
    Object? h = null,
    Object? l = null,
    Object? c = null,
    Object? t = null,
    Object? v = null,
    Object? s = null,
  }) {
    return _then(_value.copyWith(
      o: null == o
          ? _value.o
          : o // ignore: cast_nullable_to_non_nullable
              as List<double>,
      h: null == h
          ? _value.h
          : h // ignore: cast_nullable_to_non_nullable
              as List<double>,
      l: null == l
          ? _value.l
          : l // ignore: cast_nullable_to_non_nullable
              as List<double>,
      c: null == c
          ? _value.c
          : c // ignore: cast_nullable_to_non_nullable
              as List<double>,
      t: null == t
          ? _value.t
          : t // ignore: cast_nullable_to_non_nullable
              as List<int>,
      v: null == v
          ? _value.v
          : v // ignore: cast_nullable_to_non_nullable
              as List<int>,
      s: null == s
          ? _value.s
          : s // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CandleDataApiModelImplCopyWith<$Res>
    implements $CandleDataApiModelCopyWith<$Res> {
  factory _$$CandleDataApiModelImplCopyWith(_$CandleDataApiModelImpl value,
          $Res Function(_$CandleDataApiModelImpl) then) =
      __$$CandleDataApiModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<double> o,
      List<double> h,
      List<double> l,
      List<double> c,
      List<int> t,
      List<int> v,
      String s});
}

/// @nodoc
class __$$CandleDataApiModelImplCopyWithImpl<$Res>
    extends _$CandleDataApiModelCopyWithImpl<$Res, _$CandleDataApiModelImpl>
    implements _$$CandleDataApiModelImplCopyWith<$Res> {
  __$$CandleDataApiModelImplCopyWithImpl(_$CandleDataApiModelImpl _value,
      $Res Function(_$CandleDataApiModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CandleDataApiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? o = null,
    Object? h = null,
    Object? l = null,
    Object? c = null,
    Object? t = null,
    Object? v = null,
    Object? s = null,
  }) {
    return _then(_$CandleDataApiModelImpl(
      o: null == o
          ? _value._o
          : o // ignore: cast_nullable_to_non_nullable
              as List<double>,
      h: null == h
          ? _value._h
          : h // ignore: cast_nullable_to_non_nullable
              as List<double>,
      l: null == l
          ? _value._l
          : l // ignore: cast_nullable_to_non_nullable
              as List<double>,
      c: null == c
          ? _value._c
          : c // ignore: cast_nullable_to_non_nullable
              as List<double>,
      t: null == t
          ? _value._t
          : t // ignore: cast_nullable_to_non_nullable
              as List<int>,
      v: null == v
          ? _value._v
          : v // ignore: cast_nullable_to_non_nullable
              as List<int>,
      s: null == s
          ? _value.s
          : s // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CandleDataApiModelImpl implements _CandleDataApiModel {
  const _$CandleDataApiModelImpl(
      {required final List<double> o,
      required final List<double> h,
      required final List<double> l,
      required final List<double> c,
      required final List<int> t,
      required final List<int> v,
      required this.s})
      : _o = o,
        _h = h,
        _l = l,
        _c = c,
        _t = t,
        _v = v;

  factory _$CandleDataApiModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CandleDataApiModelImplFromJson(json);

  final List<double> _o;
  @override
  List<double> get o {
    if (_o is EqualUnmodifiableListView) return _o;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_o);
  }

// open prices
  final List<double> _h;
// open prices
  @override
  List<double> get h {
    if (_h is EqualUnmodifiableListView) return _h;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_h);
  }

// high prices
  final List<double> _l;
// high prices
  @override
  List<double> get l {
    if (_l is EqualUnmodifiableListView) return _l;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_l);
  }

// low prices
  final List<double> _c;
// low prices
  @override
  List<double> get c {
    if (_c is EqualUnmodifiableListView) return _c;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_c);
  }

// close prices
  final List<int> _t;
// close prices
  @override
  List<int> get t {
    if (_t is EqualUnmodifiableListView) return _t;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_t);
  }

// timestamps
  final List<int> _v;
// timestamps
  @override
  List<int> get v {
    if (_v is EqualUnmodifiableListView) return _v;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_v);
  }

// volumes
  @override
  final String s;

  @override
  String toString() {
    return 'CandleDataApiModel(o: $o, h: $h, l: $l, c: $c, t: $t, v: $v, s: $s)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandleDataApiModelImpl &&
            const DeepCollectionEquality().equals(other._o, _o) &&
            const DeepCollectionEquality().equals(other._h, _h) &&
            const DeepCollectionEquality().equals(other._l, _l) &&
            const DeepCollectionEquality().equals(other._c, _c) &&
            const DeepCollectionEquality().equals(other._t, _t) &&
            const DeepCollectionEquality().equals(other._v, _v) &&
            (identical(other.s, s) || other.s == s));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_o),
      const DeepCollectionEquality().hash(_h),
      const DeepCollectionEquality().hash(_l),
      const DeepCollectionEquality().hash(_c),
      const DeepCollectionEquality().hash(_t),
      const DeepCollectionEquality().hash(_v),
      s);

  /// Create a copy of CandleDataApiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandleDataApiModelImplCopyWith<_$CandleDataApiModelImpl> get copyWith =>
      __$$CandleDataApiModelImplCopyWithImpl<_$CandleDataApiModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CandleDataApiModelImplToJson(
      this,
    );
  }
}

abstract class _CandleDataApiModel implements CandleDataApiModel {
  const factory _CandleDataApiModel(
      {required final List<double> o,
      required final List<double> h,
      required final List<double> l,
      required final List<double> c,
      required final List<int> t,
      required final List<int> v,
      required final String s}) = _$CandleDataApiModelImpl;

  factory _CandleDataApiModel.fromJson(Map<String, dynamic> json) =
      _$CandleDataApiModelImpl.fromJson;

  @override
  List<double> get o; // open prices
  @override
  List<double> get h; // high prices
  @override
  List<double> get l; // low prices
  @override
  List<double> get c; // close prices
  @override
  List<int> get t; // timestamps
  @override
  List<int> get v; // volumes
  @override
  String get s;

  /// Create a copy of CandleDataApiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandleDataApiModelImplCopyWith<_$CandleDataApiModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
