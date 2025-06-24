import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasources/powersync/powersync_database.dart';

part 'core_providers.g.dart';

// PowerSync Database Provider
@riverpod
AppPowerSyncDatabase powerSyncDatabase(Ref ref) {
  return AppPowerSyncDatabase.instance;
}

// Hive Provider
@riverpod
HiveInterface hive(Ref ref) {
  return Hive;
}

// Current Tenant Provider
@riverpod
class CurrentTenant extends _$CurrentTenant {
  @override
  String? build() => null;

  void setTenant(String tenantId) {
    state = tenantId;
  }

  void clearTenant() {
    state = null;
  }
}

// Current Branch Provider
@riverpod
class CurrentBranch extends _$CurrentBranch {
  @override
  String? build() => null;

  void setBranch(String branchId) {
    state = branchId;
  }

  void clearBranch() {
    state = null;
  }
}

// Auth State Provider
@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() => false;

  void setAuthenticated(bool isAuthenticated) {
    state = isAuthenticated;
  }
}

// Loading State Provider
@riverpod
class GlobalLoading extends _$GlobalLoading {
  @override
  bool build() => false;

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}