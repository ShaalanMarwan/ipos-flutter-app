import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    required String role,
    required String tenantId,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  // Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      tenantId: tenantId,
      branchId: null, // Not provided by backend user object
      email: email,
      name: _buildFullName(),
      role: _parseRole(role),
      phone: null, // Not in current backend model
      avatarUrl: null, // Not in current backend model
      isActive: true, // Assume active if user exists
      createdAt: DateTime.now(), // Backend doesn't provide this in auth response
      updatedAt: DateTime.now(), // Backend doesn't provide this in auth response
    );
  }

  // Convert from domain entity
  static UserModel fromEntity(User user) {
    final nameParts = user.name.split(' ');
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: nameParts.isNotEmpty ? nameParts.first : null,
      lastName: nameParts.length > 1 ? nameParts.skip(1).join(' ') : null,
      role: _roleToString(user.role),
      tenantId: user.tenantId,
    );
  }

  String _buildFullName() {
    final parts = <String>[];
    if (firstName != null) parts.add(firstName!);
    if (lastName != null) parts.add(lastName!);
    return parts.isNotEmpty ? parts.join(' ') : email.split('@').first;
  }

  static UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'manager':
        return UserRole.manager;
      case 'cashier':
      case 'kitchen_staff':
      case 'delivery_driver':
      case 'staff':
        return UserRole.staff;
      default:
        return UserRole.staff;
    }
  }

  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'ADMIN'; // Map super admin to admin for backend
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.manager:
        return 'MANAGER';
      case UserRole.staff:
        return 'STAFF';
    }
  }
}