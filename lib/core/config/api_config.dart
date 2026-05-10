class ApiConfig {
  // Production sales-system server. Mobile uses HTTP only — change to HTTPS when SSL is set up.
  static const String baseUrl = 'http://15.164.220.51';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Endpoints
  static const String login = '/api/auth/login';
  static const String me = '/api/auth/me';
  static const String products = '/api/products';
  static const String categories = '/api/categories';
}
