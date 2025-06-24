import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    // First check if we have a stored user
    final storedUserResult = await repository.getStoredUser();
    
    return storedUserResult.fold(
      (failure) => Left(failure),
      (storedUser) async {
        if (storedUser != null) {
          // Return stored user for offline support
          return Right(storedUser);
        }
        
        // No stored user, fetch from server
        final userResult = await repository.getCurrentUser();
        
        return userResult.fold(
          (failure) => Left(failure),
          (user) async {
            // Save user for offline access
            await repository.saveUser(user);
            return Right(user);
          },
        );
      },
    );
  }

  // Stream for real-time user updates
  Stream<User?> watch() {
    return repository.watchCurrentUser();
  }
}