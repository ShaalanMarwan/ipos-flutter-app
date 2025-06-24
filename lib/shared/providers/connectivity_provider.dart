import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'connectivity_provider.g.dart';

@riverpod
Stream<ConnectivityResult> connectivity(Ref ref) {
  return Connectivity().onConnectivityChanged.map((results) => 
    results.isEmpty ? ConnectivityResult.none : results.first);
}

@riverpod
Future<bool> isConnected(Ref ref) async {
  final results = await Connectivity().checkConnectivity();
  return !results.contains(ConnectivityResult.none);
}