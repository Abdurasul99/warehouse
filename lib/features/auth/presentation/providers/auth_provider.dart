import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(localStorageServiceProvider).requireValue;
  final remote = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remote, storage, ref.watch(apiClientProvider));
});

final localStorageServiceProvider = FutureProvider<LocalStorageService>((ref) async {
  return LocalStorageService.getInstance();
});

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    await ref.watch(localStorageServiceProvider.future);
    final repo = ref.read(authRepositoryProvider);
    return repo.getCurrentUser();
  }

  Future<bool> login(String username, String password) async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.login(username, password);
    state = AsyncValue.data(user);
    return user != null;
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncValue.data(null);
  }
}

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );
});
