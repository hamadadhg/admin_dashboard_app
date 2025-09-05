import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../users/controllers/user_controller.dart';
import '../../categories/controllers/category_controller.dart';
import '../../../domain/usecase/user_usecase.dart';
import '../../../domain/usecase/category_usecase.dart';
import '../../../data/providers/api_provider.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/repository/category_repository.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;

  late final AuthController authController;
  late final UserController userController;
  late final CategoryController categoryController;

  late final UserUseCase _userUseCase;
  late final CategoryUseCase _categoryUseCase;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _initializeUseCases();
  }

  void _initializeControllers() {
    authController = Get.find<AuthController>();
    userController = Get.put(UserController());
    categoryController = Get.put(CategoryController());
  }

  void _initializeUseCases() {
    final apiProvider = ApiProvider();
    _userUseCase = UserUseCase(UserRepository(apiProvider));
    _categoryUseCase = CategoryUseCase(CategoryRepository(apiProvider));
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void navigateToAddCategory() {
    Get.toNamed('/add-category');
  }

  void navigateToUsers() {
    selectedIndex.value = 1;
  }

  void navigateToCategories() {
    selectedIndex.value = 2;
  }

  Future<void> logout() async {
    await authController.logout();
  }

  Future<void> refreshDashboard() async {
    await userController.refreshUsers();
    await categoryController.fetchCategories();
  }

  Map<String, dynamic> getDashboardStats() {
    return {
      'totalUsers': userController.userCount.value,
      'totalCategories': categoryController.categories.length,
      'adminName': authController.currentAdmin.value?.mobile ?? 'Admin',
    };
  }
}


