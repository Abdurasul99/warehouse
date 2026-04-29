import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final storage = await ref.watch(localStorageServiceProvider.future);
    return Locale(storage.locale);
  }

  Future<void> setLocale(String languageCode) async {
    final storage = await ref.read(localStorageServiceProvider.future);
    await storage.setLocale(languageCode);
    state = AsyncValue.data(Locale(languageCode));
  }
}
