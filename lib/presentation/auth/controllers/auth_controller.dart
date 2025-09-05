import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/usecase/auth_usecase.dart'; // Corrected import
import '../../../data/models/admin_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../domain/repository/auth_repository.dart'; // Corrected import

class AuthController extends GetxController {
  late final AuthUseCase _authUseCase; // Corrected variable name

  // Observable variables
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final Rx<AdminModel?> currentAdmin = Rx<AdminModel?>(null);
  final errorMessage = ''.obs;

  // Form controllers
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  // Form validation
  final formKey = GlobalKey<FormState>();
  final isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUseCases();
    _checkAuthStatus();
  }

  void _initializeUseCases() {
    final apiProvider = ApiProvider();
    final authRepository = AuthRepository(apiProvider);
    _authUseCase = AuthUseCase(authRepository); // Corrected variable name
  }

  // Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    try {
      final loggedIn = await _authUseCase.isUserLoggedIn(); // Corrected method call
      isLoggedIn.value = loggedIn;

      if (loggedIn) {
        // Navigate to home if already logged in
        Get.offAllNamed('/home');
      }
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }

  // Login function
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authUseCase.login(
        mobileController.text.trim(), // Removed named parameters
        passwordController.text.trim(), // Removed named parameters
      );

      if (response.success && response.data != null) {
        currentAdmin.value = response.data!.admin;
        isLoggedIn.value = true;
        await _authUseCase.saveToken(response.data!.token); // Save token

        // Clear form
        mobileController.clear();
        passwordController.clear();

        // Show success message
        Get.snackbar(
          'Success',
          'Login successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Navigate to home
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function
  Future<void> logout() async {
    isLoading.value = true;

    try {
      final response = await _authUseCase.logout();

      if (response.success) {
        currentAdmin.value = null;
        isLoggedIn.value = false;
        await _authUseCase.clearToken(); // Clear token

        Get.snackbar(
          'Success',
          'Logged out successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Navigate to login
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred during logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Form validators
  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  @override
  void onClose() {
    mobileController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}


