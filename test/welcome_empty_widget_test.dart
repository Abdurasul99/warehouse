import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_system_warehouse_mobile/core/theme/app_theme.dart';
import 'package:sales_system_warehouse_mobile/features/dashboard/presentation/widgets/welcome_empty_widget.dart';
import 'package:sales_system_warehouse_mobile/l10n/app_localizations.dart';

Widget _wrapped(Widget child) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => Scaffold(body: child),
      ),
      GoRoute(
        path: '/dummy',
        name: 'product-create',
        builder: (_, __) => const Scaffold(body: Text('create')),
      ),
    ],
  );
  return MaterialApp.router(
    theme: AppTheme.light,
    locale: const Locale('uz'),
    supportedLocales: const [Locale('uz'), Locale('ru')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    routerConfig: router,
  );
}

void main() {
  testWidgets('WelcomeEmptyWidget shows title, subtitle and CTA',
      (tester) async {
    await tester.pumpWidget(_wrapped(const WelcomeEmptyWidget()));
    await tester.pumpAndSettle();

    expect(find.text('Ombor boʻsh'), findsOneWidget);
    expect(find.text('Birinchi mahsulotni qoʻshing va analitika faol boʻladi.'),
        findsOneWidget);
    expect(find.text('Birinchi mahsulotni qoʻshish'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
