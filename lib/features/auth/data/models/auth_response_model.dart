import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import 'user_model.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
  }) = _AuthResponseModel;

  const AuthResponseModel._();

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => 
      _$AuthResponseModelFromJson(json);

  // Convert to domain entities
  (AuthToken, User) toEntities() {
    // JWT tokens typically expire in 1 hour, but we'll calculate from current time
    // In a real app, you might want to decode the JWT to get actual expiry
    final token = AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      tokenType: 'Bearer',
    );

    final userEntity = user.toEntity();

    return (token, userEntity);
  }
}