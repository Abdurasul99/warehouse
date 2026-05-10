import '../../../../core/utils/enums.dart';
import '../../../../shared/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> login(String username, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  bool isUsernameTaken(String username);
  Future<UserModel> register({
    required String name,
    required String username,
    required String password,
    required UserRole role,
    String language,
  });
}
