import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String orders = '/orders';
  static const String orderDetails = '/orders/details';
  static const String newOrder = '/orders/new';
  static const String kitchen = '/kitchen';
  static const String inventory = '/inventory';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String profile = '/profile';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Splash Screen')),
          ),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Login Screen')),
          ),
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Dashboard')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}