import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/auth_token.dart';

abstract class AuthRepository {
  // Authentication methods
  Future<Either<Failure, AuthToken>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthToken>> refreshToken({
    required String refreshToken,
  });

  Future<Either<Failure, void>> logout();

  // User methods
  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // Token storage methods
  Future<Either<Failure, AuthToken?>> getStoredToken();
  
  Future<Either<Failure, void>> saveToken(AuthToken token);
  
  Future<Either<Failure, void>> deleteToken();

  // User storage methods
  Future<Either<Failure, User?>> getStoredUser();
  
  Future<Either<Failure, void>> saveUser(User user);
  
  Future<Either<Failure, void>> deleteUser();

  // Real-time streams
  Stream<User?> watchCurrentUser();
  
  Stream<bool> watchAuthState();
}