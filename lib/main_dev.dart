import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/environment.dart';
import 'app.dart';

void main() {
  // Enable debug painting
  if (kDebugMode) {
    // debugPaintSizeEnabled = true;
  }
  
  Environment.initialize(Environment.development);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}