import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/models/user_model.dart';

class AuthLoginResult {
  final String token;
  final UserModel user;
  AuthLoginResult({required this.token, required this.user});
}

class AuthRemoteDataSource {
  final ApiClient _api;
  AuthRemoteDataSource(this._api);

  Future<AuthLoginResult> login(String login, String password) async {
    final res = await _api.post(
      ApiConfig.login,
      body: {'login': login, 'password': password},
    );
    if (res is! Map || res['token'] is! String || res['user'] is! Map) {
      throw ApiException(500, 'Unexpected login response shape');
    }
    final token = res['token'] as String;
    final user = UserModel.fromServerJson(Map<String, dynamic>.from(res['user'] as Map));
    return AuthLoginResult(token: token, user: user);
  }
}
