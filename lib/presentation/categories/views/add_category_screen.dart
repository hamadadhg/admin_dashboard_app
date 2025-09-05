import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  late final CategoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CategoryController(), tag: 'add-category');
  }

  @override
  void dispose() {
    Get.delete<CategoryController>(tag: 'add-category');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category Name Field
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Category Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          labelText: 'Category Name',
                          hintText: 'Enter category name',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        validator: controller.validateName,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Image Selection
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Category Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Image Preview or Placeholder
                      Obx(() {
                        final file = controller.selectedImage.value;
                        final bytes = controller.selectedImageBytes.value;

                        if (kIsWeb && bytes != null) {
                          // Web → display memory image
                          return Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                bytes,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else if (!kIsWeb && file != null) {
                          // Mobile/Desktop → display file image
                          return Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                file,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          // Placeholder
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_outlined,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 8),
                                Text('No image selected',
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          );
                        }
                      }),

                      const SizedBox(height: 16),

                      // Image Selection Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: controller.showImagePickerOptions,
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text('Select Image'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Error Message
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink()),

              // Add Category Button
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.addCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Add Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )),
              const SizedBox(height: 16),

              // Cancel Button
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
