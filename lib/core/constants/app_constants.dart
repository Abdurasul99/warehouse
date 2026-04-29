class AppRoutes {
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String productList = 'product-list';
  static const String productCreate = 'product-create';
  static const String productDetail = 'product-detail';
  static const String productEdit = 'product-edit';
  static const String stockIn = 'stock-in';
  static const String stockOut = 'stock-out';
  static const String inventory = 'inventory-check';
  static const String movements = 'movement-history';
  static const String settings = 'settings';
  static const String barcodeScanner = 'barcode-scanner';
}

class AppStrings {
  static const String appName = 'Ombor Tizimi';
  static const String appNameRu = 'Система склада';
}

class AppConfig {
  static const int lowStockThreshold = 10;
  static const int movementsPageSize = 20;
  static const String defaultLanguage = 'uz';
  static const String keyLocale = 'app_locale';
  static const String keyCurrentUser = 'current_user_id';
}
