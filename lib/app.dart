import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_system_warehouse_mobile/l10n/app_localizations.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/assistant/presentation/pages/assistant_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/inventory/presentation/pages/inventory_check_page.dart';
import 'features/movements/presentation/pages/movement_history_page.dart';
import 'features/products/presentation/pages/product_detail_page.dart';
import 'features/products/presentation/pages/product_form_page.dart';
import 'features/products/presentation/pages/product_list_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/stock/presentation/pages/stock_in_page.dart';
import 'features/stock/presentation/pages/stock_out_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Router is a stable Provider — created once, never rebuilt.
// This makes logout redirect reliable.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterChangeNotifier(ref);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );
      final isOnLogin = state.matchedLocation == '/login';
      if (!isAuthenticated && !isOnLogin) return '/login';
      if (isAuthenticated && isOnLogin) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/dashboard',
            name: AppRoutes.dashboard,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardPage()),
          ),
          GoRoute(
            path: '/products',
            name: AppRoutes.productList,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProductListPage()),
            routes: [
              GoRoute(
                path: 'new',
                name: AppRoutes.productCreate,
                pageBuilder: (context, state) =>
                    const MaterialPage(child: ProductFormPage()),
              ),
              GoRoute(
                path: ':id',
                name: AppRoutes.productDetail,
                pageBuilder: (context, state) => MaterialPage(
                  child: ProductDetailPage(id: state.pathParameters['id']!),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: AppRoutes.productEdit,
                    pageBuilder: (context, state) => MaterialPage(
                      child: ProductFormPage(
                          productId: state.pathParameters['id']),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/stock-in',
            name: AppRoutes.stockIn,
            pageBuilder: (context, state) =>
                const MaterialPage(child: StockInPage()),
          ),
          GoRoute(
            path: '/stock-out',
            name: AppRoutes.stockOut,
            pageBuilder: (context, state) =>
                const MaterialPage(child: StockOutPage()),
          ),
          GoRoute(
            path: '/inventory',
            name: AppRoutes.inventory,
            pageBuilder: (context, state) =>
                const MaterialPage(child: InventoryCheckPage()),
          ),
          GoRoute(
            path: '/movements',
            name: AppRoutes.movements,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MovementHistoryPage()),
          ),
          GoRoute(
            path: '/settings',
            name: AppRoutes.settings,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsPage()),
          ),
          GoRoute(
            path: '/assistant',
            name: AppRoutes.assistant,
            pageBuilder: (context, state) =>
                const MaterialPage(child: AssistantPage()),
          ),
        ],
      ),
    ],
  );
});

class _RouterChangeNotifier extends ChangeNotifier {
  _RouterChangeNotifier(Ref ref) {
    // Listen to auth state. When user logs out (state → null),
    // notifyListeners() causes GoRouter to re-evaluate redirect → /login.
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

class WarehouseApp extends ConsumerWidget {
  const WarehouseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider).maybeWhen(
      data: (l) => l,
      orElse: () => const Locale('uz'),
    );

    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('uz'), Locale('ru')],
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
