import 'package:equatable/equatable.dart';
import '../../core/utils/enums.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final UserRole role;
  final String language;
  final String username;
  final String password;
  final String? branchId;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.language,
    required this.username,
    required this.password,
    this.branchId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role.name,
        'language': language,
        'username': username,
        'branch_id': branchId,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        role: UserRole.values.firstWhere((e) => e.name == json['role'],
            orElse: () => UserRole.salesperson),
        language: json['language'] as String? ?? 'uz',
        username: json['username'] as String,
        password: '',
        branchId: json['branch_id'] as String?,
      );

  // Maps user from sales-system /api/auth/login response into UserModel.
  // New backend roles: founder, admin, manager, cashier, seller, user.
  // Legacy roles still supported: ADMIN / SUPERADMIN / WAREHOUSE_CLERK / CASHIER.
  factory UserModel.fromServerJson(Map<String, dynamic> json) {
    final raw = (json['role'] as String? ?? '').toLowerCase();
    final UserRole role;
    switch (raw) {
      case 'founder':
      case 'admin':
      case 'superadmin':
        role = UserRole.admin;
        break;
      case 'manager':
      case 'cashier':
      case 'warehouse_clerk':
        role = UserRole.warehouseManager;
        break;
      case 'seller':
      case 'user':
      default:
        role = UserRole.warehouseWorker;
        break;
    }
    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['fullName'] as String?) ?? (json['name'] as String? ?? ''),
      role: role,
      language: json['language'] as String? ?? 'uz',
      username: (json['username'] as String?) ?? (json['login'] as String? ?? ''),
      password: '',
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    UserRole? role,
    String? language,
    String? username,
    String? password,
    String? branchId,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        language: language ?? this.language,
        username: username ?? this.username,
        password: password ?? this.password,
        branchId: branchId ?? this.branchId,
      );

  @override
  List<Object?> get props => [id, name, role, language, username, branchId];
}
