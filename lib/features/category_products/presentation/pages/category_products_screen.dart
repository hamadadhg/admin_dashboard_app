import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/di/injection.dart';
import 'package:flutter_admin_dashboard/features/category_products/domain/use_cases/add_update_product_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/category_model.dart';
import '../../../../presentation/categories/controllers/category_controller.dart';
import '../../data/models/category_products_model.dart';
import '../manager/bloc/category_products_bloc.dart';
import '../widgets/add_update_products_dialog.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key, required this.category});

  final CategoryModel category;

  String proxyUrl(String url) {
    return 'https://corsproxy.io/?${Uri.encodeFull(url)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryProductsBloc>(
      lazy: false,
      create: (context) => getIt<CategoryProductsBloc>()..add(FetchCategoryProductsEvent(id: category.id)),
      child: Scaffold(
        floatingActionButton: BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
          builder: (context, state) {
            return FloatingActionButton(
                onPressed: () {
                  showDialog(context: context, builder: (_) => AddUpdateProductsDialog(
                    category: null,
                    isUpdate: false,
                    id: category.id,
                  ));
                },
                backgroundColor: Colors.purpleAccent,
                child: const Icon(Icons.add, color: Colors.white));
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(proxyUrl(category.image)),
            radius: 20,
          ),
          title: Text(
            category.name,
          ),
        ),
        body: BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
          builder: (context, state) {
            switch (state.fetchCategoryProductsStatus) {
              case null:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case BLocStatus.init:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case BLocStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case BLocStatus.success:
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.fetchCategoryProducts!.products!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Category Image
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    proxyUrl(state.fetchCategoryProducts!.products![index].image!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // Category Info
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.fetchCategoryProducts!.products![index].name!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      state.fetchCategoryProducts!.products![index].details!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'السعر: ${state.fetchCategoryProducts!.products![index].price!}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
                                          builder: (context, state) {
                                            return PopupMenuButton<String>(
                                              onSelected: (value) {
                                                switch (value) {
                                                  case 'view':
                                                    _showCategoryDetails(state.fetchCategoryProducts!.products![index]);
                                                    break;
                                                  case 'edit':
                                                    showDialog(context: context, builder: (_) => AddUpdateProductsDialog(
                                                      category: state.fetchCategoryProducts!.products![index],
                                                      id: category.id,
                                                      isUpdate: true,
                                                    ));
                                                    break;
                                                  case 'delete':
                                                    _showCategoryDetails(state.fetchCategoryProducts!.products![index]);
                                                    break;
                                                }
                                              },
                                              itemBuilder: (BuildContext context) => [
                                                const PopupMenuItem<String>(
                                                  value: 'view',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.visibility, size: 18),
                                                      SizedBox(width: 8),
                                                      Text('View'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit, size: 18),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete, size: 18, color: Colors.red),
                                                      SizedBox(width: 8),
                                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              case BLocStatus.error:
                return Center(
                  child: Text(state.errorMessage!),
                );
            }
          },
        ),
      ),
    );
  }

  void _showCategoryDetails(CategoryProducts category) {
    Get.dialog(
      AlertDialog(
        title: const Text('Product Details'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (category.image != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      proxyUrl(category.image!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              _buildDetailRow('ID', category.id.toString()),
              const SizedBox(height: 8),
              _buildDetailRow('Name', category.name!),
              const SizedBox(height: 8),
              _buildDetailRow('details', category.details!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _deleteCategory(category) {
    final CategoryController controller = Get.find<CategoryController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.deleteCategory(category);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
