import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/admin_model.dart';
import '../../data/providers/api_provider.dart';
import '../../data/models/api_response.dart';

class AuthRepository {
  final ApiProvider apiProvider;

  AuthRepository(this.apiProvider);

  Future<ApiResponse<LoginResponse>> login(String mobile, String password) async {
    final response = await apiProvider.post(
      '/admin/login',
      {
        'mobile': mobile,
        'password': password,
      },
      fromJson: (json) => LoginResponse.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    final response = await apiProvider.post(
      '/admin/logout',
      {},
      token: await apiProvider.getToken(),
      fromJson: (json) => json, // Assuming logout returns a simple JSON object
    );
    return response;
  }

  Future<void> saveToken(String token) async {
    await apiProvider.saveToken(token);
  }

  Future<String?> getToken() async {
    return await apiProvider.getToken();
  }

  Future<void> clearToken() async {
    await apiProvider.clearToken();
  }
}


