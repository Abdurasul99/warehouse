import 'dart:convert';

import '../../../../core/network/api_client.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final LocalStorageService _storage;
  final ApiClient _api;

  AuthRepositoryImpl(this._remote, this._storage, [ApiClient? api])
      : _api = api ?? ApiClient();

  @override
  Future<UserModel?> login(String username, String password) async {
    try {
      final result = await _remote.login(username, password);
      _api.token = result.token;
      await _storage.setAuthToken(result.token);
      await _storage.setCurrentUserId(result.user.id);
      await _storage.setCurrentUserJson(jsonEncode(result.user.toJson()));
      return result.user;
    } on ApiException {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    _api.token = null;
    await _storage.setAuthToken(null);
    await _storage.setCurrentUserId(null);
    await _storage.setCurrentUserJson(null);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = _storage.authToken;
    if (token == null || token.isEmpty) return null;
    _api.token = token;
    final raw = _storage.currentUserJson;
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromJson(Map<String, dynamic>.from(jsonDecode(raw) as Map));
    } catch (_) {
      return null;
    }
  }
}
