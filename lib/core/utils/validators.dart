class Validators {
  static String? required(String? value, {String message = 'Bu maydon majburiy'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? positiveNumber(String? value, {String message = "Musbat son kiriting"}) {
    if (value == null || value.trim().isEmpty) return message;
    final n = num.tryParse(value.trim());
    if (n == null || n <= 0) return message;
    return null;
  }

  static String? positiveInt(String? value, {String message = "Musbat son kiriting"}) {
    if (value == null || value.trim().isEmpty) return message;
    final n = int.tryParse(value.trim());
    if (n == null || n <= 0) return message;
    return null;
  }

  static String? maxQuantity(String? value, int maxQty,
      {String? message}) {
    final n = int.tryParse(value?.trim() ?? '');
    if (n == null) return null;
    if (n > maxQty) return message ?? "Miqdor mavjud qoldiqdan oshib ketdi ($maxQty)";
    return null;
  }

  static String? sku(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final pattern = RegExp(r'^[A-Za-z0-9\-_]+$');
    if (!pattern.hasMatch(value.trim())) {
      return "SKU faqat harf, raqam, - va _ dan iborat bo'lishi kerak";
    }
    return null;
  }

  static String? price(String? value, {String message = "Narxni to'g'ri kiriting"}) {
    if (value == null || value.trim().isEmpty) return message;
    final n = double.tryParse(value.trim());
    if (n == null || n < 0) return message;
    return null;
  }
}
