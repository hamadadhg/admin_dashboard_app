import '../../data/models/user_model.dart';
import '../../data/models/api_response.dart';
import '../repository/user_repository.dart';

class UserUseCase {
  final UserRepository userRepository;

  UserUseCase(this.userRepository);

  Future<ApiResponse<List<UserModel>>> getUsers() {
    return userRepository.getUsers();
  }
}


