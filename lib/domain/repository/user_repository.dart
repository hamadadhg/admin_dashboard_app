import '../../data/models/user_model.dart';
import '../../data/providers/api_provider.dart';
import '../../data/models/api_response.dart';

class UserRepository {
  final ApiProvider apiProvider;

  UserRepository(this.apiProvider);

  Future<ApiResponse<List<UserModel>>> getUsers() async {
    final response = await apiProvider.get(
      '/admin/getUsers',
      fromJson: (json) => (json['users'] as List).map((i) => UserModel.fromJson(i)).toList(),
    );
    return response;
  }
}


