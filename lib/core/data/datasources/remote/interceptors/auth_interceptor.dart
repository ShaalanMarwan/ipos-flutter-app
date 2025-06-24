import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../config/constants.dart';

class AuthInterceptor extends Interceptor {
  // TODO: Use Ref for dependency injection when implementing refresh logic
  // ignore: unused_field
  final Ref _ref;
  final _storage = const FlutterSecureStorage();

  AuthInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login/register endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    // Add auth token to headers
    final token = await _storage.read(key: AppConstants.authTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add tenant context if available
    final tenantId = await _storage.read(key: AppConstants.tenantIdKey);
    if (tenantId != null) {
      options.headers['X-Tenant-Id'] = tenantId;
    }

    // Add branch context if available
    final branchId = await _storage.read(key: AppConstants.branchIdKey);
    if (branchId != null) {
      options.headers['X-Branch-Id'] = branchId;
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final refreshed = await _refreshToken();
      
      if (refreshed) {
        // Retry the request with new token
        final opts = err.requestOptions;
        final token = await _storage.read(key: AppConstants.authTokenKey);
        opts.headers['Authorization'] = 'Bearer $token';
        
        try {
          final response = await Dio().fetch(opts);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    
    handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    final authPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/forgot-password',
      '/auth/reset-password',
    ];
    return authPaths.any((p) => path.contains(p));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken == null) return false;

      // TODO: Implement refresh token logic
      // This would call the refresh endpoint and update stored tokens
      
      return false;
    } catch (e) {
      return false;
    }
  }
}