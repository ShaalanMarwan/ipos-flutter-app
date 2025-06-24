// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refresh_token_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RefreshTokenRequestDto _$RefreshTokenRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _RefreshTokenRequestDto.fromJson(json);
}

/// @nodoc
mixin _$RefreshTokenRequestDto {
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this RefreshTokenRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshTokenRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshTokenRequestDtoCopyWith<RefreshTokenRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshTokenRequestDtoCopyWith<$Res> {
  factory $RefreshTokenRequestDtoCopyWith(RefreshTokenRequestDto value,
          $Res Function(RefreshTokenRequestDto) then) =
      _$RefreshTokenRequestDtoCopyWithImpl<$Res, RefreshTokenRequestDto>;
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class _$RefreshTokenRequestDtoCopyWithImpl<$Res,
        $Val extends RefreshTokenRequestDto>
    implements $RefreshTokenRequestDtoCopyWith<$Res> {
  _$RefreshTokenRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshTokenRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
  }) {
    return _then(_value.copyWith(
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefreshTokenRequestDtoImplCopyWith<$Res>
    implements $RefreshTokenRequestDtoCopyWith<$Res> {
  factory _$$RefreshTokenRequestDtoImplCopyWith(
          _$RefreshTokenRequestDtoImpl value,
          $Res Function(_$RefreshTokenRequestDtoImpl) then) =
      __$$RefreshTokenRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class __$$RefreshTokenRequestDtoImplCopyWithImpl<$Res>
    extends _$RefreshTokenRequestDtoCopyWithImpl<$Res,
        _$RefreshTokenRequestDtoImpl>
    implements _$$RefreshTokenRequestDtoImplCopyWith<$Res> {
  __$$RefreshTokenRequestDtoImplCopyWithImpl(
      _$RefreshTokenRequestDtoImpl _value,
      $Res Function(_$RefreshTokenRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefreshTokenRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
  }) {
    return _then(_$RefreshTokenRequestDtoImpl(
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshTokenRequestDtoImpl implements _RefreshTokenRequestDto {
  const _$RefreshTokenRequestDtoImpl({required this.refreshToken});

  factory _$RefreshTokenRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshTokenRequestDtoImplFromJson(json);

  @override
  final String refreshToken;

  @override
  String toString() {
    return 'RefreshTokenRequestDto(refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTokenRequestDtoImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  /// Create a copy of RefreshTokenRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshTokenRequestDtoImplCopyWith<_$RefreshTokenRequestDtoImpl>
      get copyWith => __$$RefreshTokenRequestDtoImplCopyWithImpl<
          _$RefreshTokenRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshTokenRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _RefreshTokenRequestDto implements RefreshTokenRequestDto {
  const factory _RefreshTokenRequestDto({required final String refreshToken}) =
      _$RefreshTokenRequestDtoImpl;

  factory _RefreshTokenRequestDto.fromJson(Map<String, dynamic> json) =
      _$RefreshTokenRequestDtoImpl.fromJson;

  @override
  String get refreshToken;

  /// Create a copy of RefreshTokenRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshTokenRequestDtoImplCopyWith<_$RefreshTokenRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
