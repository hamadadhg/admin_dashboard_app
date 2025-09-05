import 'package:dio/dio.dart';
import '../../config/app_constants.dart';
import '../../data/models/admin_model.dart';
import '../../data/models/api_response.dart';
import '../../data/providers/api_provider.dart';

class AuthRepository {
  final ApiProvider _apiProvider;

  AuthRepository(this._apiProvider);

  // Login
  Future<ApiResponse<LoginResponse>> login({
    required String mobile,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({
        'mobile': mobile,
        'password': password,
      });

      final response = await _apiProvider.postFormData<LoginResponse>(
        AppConstants.loginEndpoint,
        formData: formData,
        fromJson: (json) => LoginResponse.fromJson(json),
      );

      // Save token if login successful
      if (response.success && response.data != null) {
        await _apiProvider.saveToken(response.data!.token);
      }

      return response;
    } catch (e) {
      return ApiResponse.error(
        message: 'Login failed: $e',
      );
    }
  }

  // Logout
  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    try {
      final response = await _apiProvider.post<Map<String, dynamic>>(
        AppConstants.logoutEndpoint,
        {},
        fromJson: (json) => json,
      );

      // Clear token after logout
      if (response.success) {
        await _apiProvider.clearToken();
      }

      return response;
    } catch (e) {
      return ApiResponse.error(
        message: 'Logout failed: $e',
      );
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiProvider.getToken();
    return token != null && token.isNotEmpty;
  }

  // Get current token
  Future<String?> getCurrentToken() async {
    return await _apiProvider.getToken();
  }

  // Clear authentication data
  Future<void> clearAuthData() async {
    await _apiProvider.clearToken();
  }
}
