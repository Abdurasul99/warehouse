import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _prefs;

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._internal();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  LocalStorageService._internal();

  String get locale => _prefs?.getString(AppConfig.keyLocale) ?? AppConfig.defaultLanguage;

  Future<void> setLocale(String locale) async {
    await _prefs?.setString(AppConfig.keyLocale, locale);
  }

  String? get currentUserId => _prefs?.getString(AppConfig.keyCurrentUser);

  Future<void> setCurrentUserId(String? id) async {
    if (id == null) {
      await _prefs?.remove(AppConfig.keyCurrentUser);
    } else {
      await _prefs?.setString(AppConfig.keyCurrentUser, id);
    }
  }

  String? get authToken => _prefs?.getString(AppConfig.keyAuthToken);

  Future<void> setAuthToken(String? token) async {
    if (token == null) {
      await _prefs?.remove(AppConfig.keyAuthToken);
    } else {
      await _prefs?.setString(AppConfig.keyAuthToken, token);
    }
  }

  String? get currentUserJson => _prefs?.getString(AppConfig.keyCurrentUserJson);

  Future<void> setCurrentUserJson(String? json) async {
    if (json == null) {
      await _prefs?.remove(AppConfig.keyCurrentUserJson);
    } else {
      await _prefs?.setString(AppConfig.keyCurrentUserJson, json);
    }
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}
