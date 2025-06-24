import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/data/datasources/remote/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_dto.dart';
import '../models/refresh_token_request_dto.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    required String tenantId,
  });

  Future<AuthResponseModel> refreshToken({
    required String refreshToken,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    required String tenantId,
  }) async {
    try {
      final requestDto = LoginRequestDto(
        email: email,
        password: password,
      );

      final response = await apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: requestDto.toJson(),
        options: Options(
          headers: {
            'X-Tenant-ID': tenantId,
          },
        ),
      );

      return AuthResponseModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final requestDto = RefreshTokenRequestDto(
        refreshToken: refreshToken,
      );

      final response = await apiClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: requestDto.toJson(),
      );

      return AuthResponseModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Token refresh failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post<void>('/auth/logout');
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>('/auth/me');
      return UserModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get user: ${e.toString()}');
    }
  }
}