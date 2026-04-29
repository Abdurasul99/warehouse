import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_system_warehouse_mobile/app.dart';
import 'package:sales_system_warehouse_mobile/shared/mock_data/mock_database.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    MockDatabase().reset();
  });

  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: WarehouseApp()));
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Login page does not expose demo credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: WarehouseApp()));
    await tester.pumpAndSettle();

    expect(find.text('admin'), findsNothing);
    expect(find.text('admin123'), findsNothing);
    expect(find.text('manager'), findsNothing);
    expect(find.text('manager123'), findsNothing);
    expect(find.text('worker'), findsNothing);
    expect(find.text('worker123'), findsNothing);
    expect(find.text("DEMO KIRISH MA'LUMOTLARI"), findsNothing);
  });
}
