import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    @Default('Bearer') String tokenType,
  }) = _AuthToken;

  const AuthToken._();

  // Business logic methods
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Duration get timeUntilExpiry => expiresAt.difference(DateTime.now());
  
  bool get shouldRefresh {
    final remainingTime = timeUntilExpiry;
    // Refresh if less than 5 minutes remaining
    return remainingTime.inMinutes < 5 && !isExpired;
  }
  
  String get authorizationHeader => '$tokenType $accessToken';
}