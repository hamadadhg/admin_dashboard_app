import 'package:get/get.dart';
import '../../../domain/usecase/user_usecase.dart'; // Corrected import
import '../../../data/models/user_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../domain/repository/user_repository.dart'; // Corrected import

class UserController extends GetxController {
  late final UserUseCase _userUseCase; // Corrected variable name

  // Observable variables
  final isLoading = false.obs;
  final users = <UserModel>[].obs;
  final userCount = 0.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUseCases();
    fetchUsers();
  }

  void _initializeUseCases() {
    final apiProvider = ApiProvider();
    final userRepository = UserRepository(apiProvider); // Corrected repository
    _userUseCase = UserUseCase(userRepository); // Corrected use case
  }

  // Fetch users from API
  Future<void> fetchUsers() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _userUseCase.getUsers(); // Corrected method call

      if (response.success && response.data != null) {
        users.value = response.data!;
        userCount.value = response.data!.length; // Assuming count is length of list
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch users';
      Get.snackbar(
        'Error',
        'Failed to fetch users',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh users
  Future<void> refreshUsers() async {
    await fetchUsers();
  }

  // Search users by username or mobile
  List<UserModel> searchUsers(String query) {
    if (query.isEmpty) {
      return users;
    }

    return users.where((user) {
      return user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.mobile.contains(query);
    }).toList();
  }

  // Get user by mobile
  UserModel? getUserByMobile(String mobile) {
    try {
      return users.firstWhere((user) => user.mobile == mobile);
    } catch (e) {
      return null;
    }
  }

  // Get user by username
  UserModel? getUserByUsername(String username) {
    try {
      return users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }
}


