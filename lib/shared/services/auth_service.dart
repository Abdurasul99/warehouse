import '../../core/utils/enums.dart';
import '../mock_data/mock_database.dart';
import '../models/user_model.dart';

class AuthService {
  final MockDatabase _db = MockDatabase();

  Future<UserModel?> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      return _db.users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  UserModel? getUserById(String id) {
    try {
      return _db.users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  bool isUsernameTaken(String username) {
    return _db.users.any((u) => u.username == username);
  }

  Future<UserModel> register({
    required String name,
    required String username,
    required String password,
    required UserRole role,
    String language = 'uz',
    String? branchId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final id = 'usr_${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(
      id: id,
      name: name,
      role: role,
      language: language,
      username: username,
      password: password,
      branchId: branchId ?? (_db.branches.isNotEmpty ? _db.branches.first.id : null),
    );
    _db.users.add(user);
    return user;
  }
}
