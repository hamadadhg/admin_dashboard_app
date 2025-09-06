import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection.dart';
import '../../data/models/category_products_model.dart';
import '../../domain/use_cases/add_update_product_use_case.dart';
import '../manager/bloc/category_products_bloc.dart';

class AddUpdateProductsDialog extends StatefulWidget {
  const AddUpdateProductsDialog({super.key, this.category, this.id, required this.isUpdate});

  final CategoryProducts? category;
  final int? id;
  final bool isUpdate;

  @override
  State<AddUpdateProductsDialog> createState() => _AddUpdateProductsDialogState();
}

class _AddUpdateProductsDialogState extends State<AddUpdateProductsDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category?.name);
    priceController = TextEditingController(text: widget.category?.price == null ? '' : widget.category!.price.toString());
    detailsController = TextEditingController(text: widget.category?.details);
  }

  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryProductsBloc>(),
      child: Dialog(
        child: Container(
          padding: const EdgeInsetsDirectional.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: "Details"),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    pickedImage = File(image.path);
                    Get.snackbar("Image Selected", pickedImage!.path, snackPosition: SnackPosition.BOTTOM);
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text("Pick Image"),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          context.read<CategoryProductsBloc>().add(
                            AddEditProductEvent(
                              params: AddUpdateProductParams(
                                name: nameController.text,
                                price: priceController.text,
                                details: detailsController.text,
                                image: pickedImage,
                                categoryId: widget.id!,
                                isUpdate: widget.isUpdate,
                              ),
                            ),
                          );
                        },
                        child: const Text('Save'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
