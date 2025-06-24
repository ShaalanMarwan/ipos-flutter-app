import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/environment.dart';
import 'app.dart';

void main() {
  Environment.initialize(Environment.staging);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}