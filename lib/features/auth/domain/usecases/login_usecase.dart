import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/config/constants.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, (AuthToken, User)>> call(LoginParams params) async {
    // Validate email
    if (!AppConstants.emailRegex.hasMatch(params.email)) {
      return const Left(ValidationFailure(
        message: 'Please enter a valid email address',
      ));
    }

    // Validate password
    if (params.password.length < 6) {
      return const Left(ValidationFailure(
        message: 'Password must be at least 6 characters',
      ));
    }

    // Attempt login
    final loginResult = await repository.login(
      email: params.email.toLowerCase().trim(),
      password: params.password,
    );

    return loginResult.fold(
      (failure) => Left(failure),
      (token) async {
        // Save token
        await repository.saveToken(token);
        
        // Get user information
        final userResult = await repository.getCurrentUser();
        
        return userResult.fold(
          (failure) => Left(failure),
          (user) async {
            // Save user
            await repository.saveUser(user);
            return Right((token, user));
          },
        );
      },
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}