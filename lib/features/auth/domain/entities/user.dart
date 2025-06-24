import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

enum UserRole {
  superAdmin,
  admin,
  manager,
  staff,
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String tenantId,
    String? branchId,
    required String email,
    required String name,
    required UserRole role,
    String? phone,
    String? avatarUrl,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  const User._();

  // Business logic methods
  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get isAdmin => role == UserRole.admin;
  bool get isManager => role == UserRole.manager;
  bool get isStaff => role == UserRole.staff;
  
  bool canManageUsers() => isSuperAdmin || isAdmin;
  bool canManageProducts() => !isStaff;
  bool canViewReports() => !isStaff;
  bool canManageSettings() => isSuperAdmin || isAdmin;
  bool canAccessBranch(String branchId) => 
      isSuperAdmin || this.branchId == branchId;
}