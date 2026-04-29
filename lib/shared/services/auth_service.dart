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
}
