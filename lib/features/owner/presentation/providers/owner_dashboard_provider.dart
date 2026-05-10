import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/owner_dashboard_remote_datasource.dart';
import '../../domain/entities/owner_dashboard.dart';

final ownerDashboardDataSourceProvider =
    Provider<OwnerDashboardRemoteDataSource>((ref) {
  return OwnerDashboardRemoteDataSource(ref.watch(apiClientProvider));
});

final ownerDashboardProvider =
    AsyncNotifierProvider<OwnerDashboardNotifier, OwnerDashboard>(
  OwnerDashboardNotifier.new,
);

class OwnerDashboardNotifier extends AsyncNotifier<OwnerDashboard> {
  @override
  Future<OwnerDashboard> build() async {
    return ref.read(ownerDashboardDataSourceProvider).fetch();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(ownerDashboardDataSourceProvider).fetch(),
    );
  }
}
