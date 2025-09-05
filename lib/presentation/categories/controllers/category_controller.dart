import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/usecase/category_usecase.dart'; // Corrected import
import '../../../data/models/category_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../domain/repository/category_repository.dart'; // Corrected import

class CategoryController extends GetxController {
  late final CategoryUseCase _categoryUseCase; // Corrected variable name
  final ImagePicker _imagePicker = ImagePicker();
  final Rx<Uint8List?> selectedImageBytes = Rx<Uint8List?>(null); // for web

  // Observable variables
  final isLoading = false.obs;
  final categories = <CategoryModel>[].obs;
  final errorMessage = ''.obs;
  final selectedImage = Rx<File?>(null);

  // Form controllers
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _initializeUseCases();
    fetchCategories(); // Fetch categories on init
  }

  void _initializeUseCases() {
    final apiProvider = ApiProvider();
    final categoryRepository = CategoryRepository(apiProvider); // Corrected repository
    _categoryUseCase = CategoryUseCase(categoryRepository); // Corrected use case
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          selectedImageBytes.value = await pickedFile.readAsBytes();
        } else {
          selectedImage.value = File(pickedFile.path);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          selectedImageBytes.value = await pickedFile.readAsBytes();
        } else {
          selectedImage.value = File(pickedFile.path);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Show image picker options
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickImageFromCamera();
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 50, color: Colors.blue),
                      SizedBox(height: 8),
                      Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickImageFromGallery();
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.photo_library, size: 50, color: Colors.green),
                      SizedBox(height: 8),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Remove selected image
  void removeSelectedImage() {
    selectedImage.value = null;
    selectedImageBytes.value = null;
  }

  // Add category
  Future<void> addCategory() async {
    if (!formKey.currentState!.validate()) return;

    if (!kIsWeb && selectedImage.value == null) {
      Get.snackbar('Error', 'Please select an image',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (kIsWeb && selectedImageBytes.value == null) {
      Get.snackbar('Error', 'Please select an image',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    final response = await _categoryUseCase.addCategory(
      nameController.text.trim(),
      selectedImageBytes.value!,
    );

    if (response.success && response.data != null) {
      categories.add(response.data!);

      nameController.clear();
      selectedImage.value = null;
      selectedImageBytes.value = null;

      Get.snackbar('Success', 'Category added successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.back();
    } else {
      errorMessage.value = response.message;
      Get.snackbar('Error', response.message,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading.value = false;
    // try {
    //
    // } catch (e) {
    //   errorMessage.value = 'Failed to add category';
    //   Get.snackbar('Error', 'Failed to add category',
    //       backgroundColor: Colors.red, colorText: Colors.white);
    // } finally {
    //
    // }
  }

  // Fetch categories from API
  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _categoryUseCase.getCategories();

      print(response.data![0].image);

      if (response.success && response.data != null) {
        categories.value = response.data!;
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch categories';
      Get.snackbar(
        'Error',
        'Failed to fetch categories',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Form validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category name is required';
    }
    if (value.length < 2) {
      return 'Category name must be at least 2 characters';
    }
    return null;
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
  }
}


