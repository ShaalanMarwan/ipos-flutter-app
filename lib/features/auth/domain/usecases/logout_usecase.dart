import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    // First try to logout from server
    final logoutResult = await repository.logout();
    
    // Regardless of server response, clear local data
    await repository.deleteToken();
    await repository.deleteUser();
    
    return logoutResult;
  }
}