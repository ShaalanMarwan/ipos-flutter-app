abstract class Environment {
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';

  static late String _environment;
  static late EnvironmentConfig _config;

  static void initialize(String environment) {
    _environment = environment;
    _config = _getConfig(environment);
  }

  static String get current => _environment;
  static EnvironmentConfig get config => _config;

  static EnvironmentConfig _getConfig(String environment) {
    switch (environment) {
      case development:
        return const EnvironmentConfig(
          apiBaseUrl: 'http://localhost:3000',
          wsBaseUrl: 'ws://localhost:3000',
          powerSyncUrl: 'http://localhost:8080',
          logLevel: 'debug',
          enableLogging: true,
          enableAnalytics: false,
        );
      case staging:
        return const EnvironmentConfig(
          apiBaseUrl: 'https://staging-api.ipos.com',
          wsBaseUrl: 'wss://staging-api.ipos.com',
          powerSyncUrl: 'https://staging-sync.ipos.com',
          logLevel: 'info',
          enableLogging: true,
          enableAnalytics: true,
        );
      case production:
        return const EnvironmentConfig(
          apiBaseUrl: 'https://api.ipos.com',
          wsBaseUrl: 'wss://api.ipos.com',
          powerSyncUrl: 'https://sync.ipos.com',
          logLevel: 'error',
          enableLogging: false,
          enableAnalytics: true,
        );
      default:
        throw Exception('Invalid environment: $environment');
    }
  }
}

class EnvironmentConfig {
  final String apiBaseUrl;
  final String wsBaseUrl;
  final String powerSyncUrl;
  final String logLevel;
  final bool enableLogging;
  final bool enableAnalytics;

  const EnvironmentConfig({
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.powerSyncUrl,
    required this.logLevel,
    required this.enableLogging,
    required this.enableAnalytics,
  });
}