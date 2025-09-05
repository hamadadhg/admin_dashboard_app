import '../repositories/auth_repository.dart';
import '../../data/models/admin_model.dart';
import '../../data/models/api_response.dart';

class AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCases(this._authRepository);

  // Login use case
  Future<ApiResponse<LoginResponse>> login({
    required String mobile,
    required String password,
  }) async {
    // Validate input
    if (mobile.isEmpty) {
      return ApiResponse.error(message: 'Mobile number is required');
    }

    if (password.isEmpty) {
      return ApiResponse.error(message: 'Password is required');
    }

    if (password.length < 8) {
      return ApiResponse.error(
          message: 'Password must be at least 8 characters');
    }

    // Validate mobile number format (basic validation)
    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
      return ApiResponse.error(
          message: 'Please enter a valid 10-digit mobile number');
    }

    return await _authRepository.login(
      mobile: mobile,
      password: password,
    );
  }

  // Logout use case
  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    return await _authRepository.logout();
  }

  // Check authentication status
  Future<bool> isUserLoggedIn() async {
    return await _authRepository.isLoggedIn();
  }

  // Get current token
  Future<String?> getCurrentToken() async {
    return await _authRepository.getCurrentToken();
  }

  // Clear all authentication data
  Future<void> clearAuthenticationData() async {
    await _authRepository.clearAuthData();
  }
}
