import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../../domain/entities/auth_token.dart';

abstract class AuthLocalDataSource {
  Future<AuthToken?> getStoredToken();
  Future<void> saveToken(AuthToken token);
  Future<void> deleteToken();
  
  Future<UserModel?> getStoredUser();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();
  
  Future<String?> getTenantId();
  Future<void> saveTenantId(String tenantId);
  Future<void> deleteTenantId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<AuthToken?> getStoredToken() async {
    try {
      final accessToken = await secureStorage.read(key: AppConstants.authTokenKey);
      final refreshToken = await secureStorage.read(key: AppConstants.refreshTokenKey);
      
      if (accessToken == null || refreshToken == null) {
        return null;
      }

      // Try to get expiry time, default to 1 hour from now if not found
      final expiryString = await secureStorage.read(key: '${AppConstants.authTokenKey}_expiry');
      final expiresAt = expiryString != null 
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(expiryString))
          : DateTime.now().add(const Duration(hours: 1));

      return AuthToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
        tokenType: 'Bearer',
      );
    } catch (e) {
      throw CacheException(message: 'Failed to get stored token: ${e.toString()}');
    }
  }

  @override
  Future<void> saveToken(AuthToken token) async {
    try {
      await secureStorage.write(key: AppConstants.authTokenKey, value: token.accessToken);
      await secureStorage.write(key: AppConstants.refreshTokenKey, value: token.refreshToken);
      await secureStorage.write(
        key: '${AppConstants.authTokenKey}_expiry', 
        value: token.expiresAt.millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save token: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await secureStorage.delete(key: AppConstants.authTokenKey);
      await secureStorage.delete(key: AppConstants.refreshTokenKey);
      await secureStorage.delete(key: '${AppConstants.authTokenKey}_expiry');
    } catch (e) {
      throw CacheException(message: 'Failed to delete token: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getStoredUser() async {
    try {
      final userJson = await secureStorage.read(key: AppConstants.userDataKey);
      if (userJson == null) return null;
      
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw CacheException(message: 'Failed to get stored user: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await secureStorage.write(key: AppConstants.userDataKey, value: userJson);
    } catch (e) {
      throw CacheException(message: 'Failed to save user: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await secureStorage.delete(key: AppConstants.userDataKey);
    } catch (e) {
      throw CacheException(message: 'Failed to delete user: ${e.toString()}');
    }
  }

  @override
  Future<String?> getTenantId() async {
    try {
      return await secureStorage.read(key: AppConstants.tenantIdKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get tenant ID: ${e.toString()}');
    }
  }

  @override
  Future<void> saveTenantId(String tenantId) async {
    try {
      await secureStorage.write(key: AppConstants.tenantIdKey, value: tenantId);
    } catch (e) {
      throw CacheException(message: 'Failed to save tenant ID: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTenantId() async {
    try {
      await secureStorage.delete(key: AppConstants.tenantIdKey);
    } catch (e) {
      throw CacheException(message: 'Failed to delete tenant ID: ${e.toString()}');
    }
  }
}