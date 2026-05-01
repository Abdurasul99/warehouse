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
  static const String assistant = 'assistant';
}

class ProductUnits {
  static const List<String> all = [
    'dona',
    'kg',
    'g',
    'l',
    'ml',
    'm',
    'cm',
    'm2',
    'm3',
    'pachka',
    'quti',
    'komplekt',
  ];

  static const Map<String, String> _uzLabels = {
    'dona': 'dona (шт)',
    'kg': 'kg (кг)',
    'g': 'g (г)',
    'l': 'l (л)',
    'ml': 'ml (мл)',
    'm': 'm (м)',
    'cm': 'cm (см)',
    'm2': 'm² (кв.м)',
    'm3': 'm³ (куб.м)',
    'pachka': 'pachka (пачка)',
    'quti': 'quti (коробка)',
    'komplekt': 'komplekt (комплект)',
  };

  static const Map<String, String> _ruLabels = {
    'dona': 'штука',
    'kg': 'кг',
    'g': 'г',
    'l': 'л',
    'ml': 'мл',
    'm': 'м',
    'cm': 'см',
    'm2': 'кв.м',
    'm3': 'куб.м',
    'pachka': 'пачка',
    'quti': 'коробка',
    'komplekt': 'комплект',
  };

  static String label(String code, String locale) {
    final map = locale == 'ru' ? _ruLabels : _uzLabels;
    return map[code] ?? code;
  }
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
