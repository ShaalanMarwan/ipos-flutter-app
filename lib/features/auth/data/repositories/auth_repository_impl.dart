import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  // Streams for real-time updates
  final BehaviorSubject<User?> _currentUserSubject = BehaviorSubject<User?>();
  final BehaviorSubject<bool> _authStateSubject = BehaviorSubject<bool>.seeded(false);

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  }) {
    _initializeAuthState();
  }

  @override
  Future<Either<Failure, AuthToken>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Get tenant ID from storage (should be set during app initialization or tenant selection)
      final tenantId = await localDataSource.getTenantId();
      if (tenantId == null) {
        return const Left(ValidationFailure(
          message: 'Tenant ID not found. Please contact support.',
        ));
      }

      // Call remote API
      final authResponse = await remoteDataSource.login(
        email: email,
        password: password,
        tenantId: tenantId,
      );

      // Extract token and user
      final (token, user) = authResponse.toEntities();

      // Save to local storage
      await localDataSource.saveToken(token);
      await localDataSource.saveUser(UserModel.fromEntity(user));

      // Update streams
      _currentUserSubject.add(user);
      _authStateSubject.add(true);

      return Right(token);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final authResponse = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );

      final (token, user) = authResponse.toEntities();

      // Save new token
      await localDataSource.saveToken(token);
      await localDataSource.saveUser(UserModel.fromEntity(user));

      // Update streams
      _currentUserSubject.add(user);
      _authStateSubject.add(true);

      return Right(token);
    } on ServerException catch (e) {
      // If refresh fails, clear local data
      await _clearLocalData();
      return Left(AuthFailure(message: e.message, code: 'REFRESH_FAILED'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      await _clearLocalData();
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Try to logout from server
      await remoteDataSource.logout();
    } on ServerException {
      // Continue with local logout even if server logout fails
    } on NetworkException {
      // Continue with local logout even if network fails
    }

    // Always clear local data
    await _clearLocalData();
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try local first for offline support
      final localUser = await localDataSource.getStoredUser();
      if (localUser != null) {
        final user = localUser.toEntity();
        _currentUserSubject.add(user);
        return Right(user);
      }

      // Fetch from server
      final userModel = await remoteDataSource.getCurrentUser();
      final user = userModel.toEntity();

      // Save locally
      await localDataSource.saveUser(userModel);
      _currentUserSubject.add(user);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    // TODO: Implement when backend supports profile updates
    return const Left(ServerFailure(message: 'Profile update not implemented'));
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // TODO: Implement when backend supports password change
    return const Left(ServerFailure(message: 'Password change not implemented'));
  }

  @override
  Future<Either<Failure, AuthToken?>> getStoredToken() async {
    try {
      final token = await localDataSource.getStoredToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(AuthToken token) async {
    try {
      await localDataSource.saveToken(token);
      _authStateSubject.add(true);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteToken() async {
    try {
      await localDataSource.deleteToken();
      _authStateSubject.add(false);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getStoredUser() async {
    try {
      final userModel = await localDataSource.getStoredUser();
      final user = userModel?.toEntity();
      if (user != null) {
        _currentUserSubject.add(user);
      }
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(User user) async {
    try {
      await localDataSource.saveUser(UserModel.fromEntity(user));
      _currentUserSubject.add(user);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser() async {
    try {
      await localDataSource.deleteUser();
      _currentUserSubject.add(null);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<User?> watchCurrentUser() {
    return _currentUserSubject.stream;
  }

  @override
  Stream<bool> watchAuthState() {
    return _authStateSubject.stream;
  }

  // Helper method to set tenant ID (should be called during app initialization)
  Future<Either<Failure, void>> setTenantId(String tenantId) async {
    try {
      await localDataSource.saveTenantId(tenantId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // Private methods
  Future<void> _initializeAuthState() async {
    try {
      final token = await localDataSource.getStoredToken();
      final user = await localDataSource.getStoredUser();
      
      final isAuthenticated = token != null && !token.isExpired && user != null;
      _authStateSubject.add(isAuthenticated);
      
      if (isAuthenticated) {
        _currentUserSubject.add(user.toEntity());
      }
    } catch (e) {
      _authStateSubject.add(false);
      _currentUserSubject.add(null);
    }
  }

  Future<void> _clearLocalData() async {
    await localDataSource.deleteToken();
    await localDataSource.deleteUser();
    _currentUserSubject.add(null);
    _authStateSubject.add(false);
  }

  void dispose() {
    _currentUserSubject.close();
    _authStateSubject.close();
  }
}