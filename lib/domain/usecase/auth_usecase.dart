import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/admin_model.dart';
import '../../data/models/api_response.dart';
import '../repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository authRepository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthUseCase(this.authRepository);

  Future<ApiResponse<LoginResponse>> login(String mobile, String password) {
    return authRepository.login(mobile, password);
  }

  Future<ApiResponse<Map<String, dynamic>>> logout() {
    return authRepository.logout();
  }

  Future<void> saveToken(String token) {
    return authRepository.saveToken(token);
  }

  Future<String?> getToken() {
    return authRepository.getToken();
  }

  Future<void> clearToken() {
    return authRepository.clearToken();
  }

  Future<bool> isUserLoggedIn() async {
    String? token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }
}


