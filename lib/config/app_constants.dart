class AppConstants {
  // Base URL - will be updated when backend is deployed
  static const String kBaseUrl = 'https://res.mustafafares.com/api';

  // API Endpoints
  static const String loginEndpoint = '/admin/login';
  static const String logoutEndpoint = '/admin/logout';
  static const String getUsersEndpoint = '/admin/getUsers';
  static const String addCategoryEndpoint = '/addCategory';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String adminDataKey = 'admin_data';

  // App Info
  static const String appName = 'Admin Dashboard';
  static const String appVersion = '1.0.0';
}
