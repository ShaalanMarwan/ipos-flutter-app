import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, AuthToken>> call() async {
    // Get stored token
    final storedTokenResult = await repository.getStoredToken();
    
    return storedTokenResult.fold(
      (failure) => Left(failure),
      (storedToken) async {
        if (storedToken == null) {
          return const Left(AuthFailure(
            message: 'No refresh token available',
            code: 'NO_TOKEN',
          ));
        }
        
        // Check if token should be refreshed
        if (!storedToken.shouldRefresh && !storedToken.isExpired) {
          // Token is still valid
          return Right(storedToken);
        }
        
        // Refresh the token
        final refreshResult = await repository.refreshToken(
          refreshToken: storedToken.refreshToken,
        );
        
        return refreshResult.fold(
          (failure) => Left(failure),
          (newToken) async {
            // Save new token
            await repository.saveToken(newToken);
            return Right(newToken);
          },
        );
      },
    );
  }

  // Check if token needs refresh
  Future<bool> shouldRefreshToken() async {
    final tokenResult = await repository.getStoredToken();
    
    return tokenResult.fold(
      (_) => true, // Error getting token, should refresh
      (token) => token == null || token.shouldRefresh || token.isExpired,
    );
  }
}