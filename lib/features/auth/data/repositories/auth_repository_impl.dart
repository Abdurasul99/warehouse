import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/auth_service.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final LocalStorageService _storage;

  AuthRepositoryImpl(this._authService, this._storage);

  @override
  Future<UserModel?> login(String username, String password) async {
    final user = await _authService.login(username, password);
    if (user != null) {
      await _storage.setCurrentUserId(user.id);
    }
    return user;
  }

  @override
  Future<void> logout() async {
    await _storage.setCurrentUserId(null);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final id = _storage.currentUserId;
    if (id == null) return null;
    return _authService.getUserById(id);
  }
}
