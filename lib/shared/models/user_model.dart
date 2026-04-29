import 'package:equatable/equatable.dart';
import '../../core/utils/enums.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final UserRole role;
  final String language;
  final String username;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.language,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role.name,
        'language': language,
        'username': username,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        role: UserRole.values.firstWhere((e) => e.name == json['role']),
        language: json['language'] as String? ?? 'uz',
        username: json['username'] as String,
        password: '',
      );

  UserModel copyWith({
    String? id,
    String? name,
    UserRole? role,
    String? language,
    String? username,
    String? password,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        language: language ?? this.language,
        username: username ?? this.username,
        password: password ?? this.password,
      );

  @override
  List<Object?> get props => [id, name, role, language, username];
}
