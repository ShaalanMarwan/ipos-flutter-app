class AppConstants {
  // API
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration wsReconnectDelay = Duration(seconds: 5);
  static const int maxRetryAttempts = 3;

  // Cache
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // Sync
  static const Duration syncInterval = Duration(minutes: 5);
  static const int syncBatchSize = 100;

  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String tenantIdKey = 'tenant_id';
  static const String branchIdKey = 'branch_id';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
}