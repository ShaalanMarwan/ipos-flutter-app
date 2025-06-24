// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$powerSyncDatabaseHash() => r'9d05a365339842933b1ac502ae0b07ec3e52f371';

/// See also [powerSyncDatabase].
@ProviderFor(powerSyncDatabase)
final powerSyncDatabaseProvider =
    AutoDisposeProvider<AppPowerSyncDatabase>.internal(
  powerSyncDatabase,
  name: r'powerSyncDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$powerSyncDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PowerSyncDatabaseRef = AutoDisposeProviderRef<AppPowerSyncDatabase>;
String _$hiveHash() => r'82e5fa0b631d691e9dabde8042330f39d839a518';

/// See also [hive].
@ProviderFor(hive)
final hiveProvider = AutoDisposeProvider<HiveInterface>.internal(
  hive,
  name: r'hiveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hiveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HiveRef = AutoDisposeProviderRef<HiveInterface>;
String _$currentTenantHash() => r'737b89dc875a8f9078ec2907a6ff6486ba88b1b0';

/// See also [CurrentTenant].
@ProviderFor(CurrentTenant)
final currentTenantProvider =
    AutoDisposeNotifierProvider<CurrentTenant, String?>.internal(
  CurrentTenant.new,
  name: r'currentTenantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentTenantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentTenant = AutoDisposeNotifier<String?>;
String _$currentBranchHash() => r'57928d852f0154678fc95797431660ab774bcde0';

/// See also [CurrentBranch].
@ProviderFor(CurrentBranch)
final currentBranchProvider =
    AutoDisposeNotifierProvider<CurrentBranch, String?>.internal(
  CurrentBranch.new,
  name: r'currentBranchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentBranchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentBranch = AutoDisposeNotifier<String?>;
String _$authStateHash() => r'e09831530c0cbbf94467025da927cef82d4d6070';

/// See also [AuthState].
@ProviderFor(AuthState)
final authStateProvider = AutoDisposeNotifierProvider<AuthState, bool>.internal(
  AuthState.new,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthState = AutoDisposeNotifier<bool>;
String _$globalLoadingHash() => r'5b4ebe3c610286599d82c5c97d9a2adda085ba97';

/// See also [GlobalLoading].
@ProviderFor(GlobalLoading)
final globalLoadingProvider =
    AutoDisposeNotifierProvider<GlobalLoading, bool>.internal(
  GlobalLoading.new,
  name: r'globalLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GlobalLoading = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
