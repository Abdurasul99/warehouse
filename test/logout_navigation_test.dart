import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_system_warehouse_mobile/app.dart';
import 'package:sales_system_warehouse_mobile/shared/mock_data/mock_database.dart';
import 'package:sales_system_warehouse_mobile/shared/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorageService.getInstance();
    await storage.setCurrentUserId('usr_01');
    await storage.setLocale('uz');
    MockDatabase().reset();
  });

  testWidgets('dashboard exposes logout action and logs out',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: WarehouseApp()));
    await tester.pumpAndSettle();

    expect(find.text('Ombor Tizimi'), findsOneWidget);
    expect(find.byIcon(Icons.logout_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.logout_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Tizimdan chiqishni tasdiqlaysizmi?'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Chiqish'));
    await tester.pumpAndSettle();

    expect(find.text('Foydalanuvchi nomi'), findsOneWidget);
  });

  testWidgets('settings renders logout controls without error box',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: WarehouseApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Sozlamalar'), findsOneWidget);
    expect(find.byType(ErrorWidget), findsNothing);
    expect(find.byIcon(Icons.logout_outlined), findsOneWidget);
    expect(find.text('Chiqish'), findsOneWidget);
  });
}
