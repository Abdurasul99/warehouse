import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'shared/mock_data/mock_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MockDatabase().initialize();
  runApp(const ProviderScope(child: WarehouseApp()));
}
