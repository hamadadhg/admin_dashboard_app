import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/category_model.dart';
import '../manager/bloc/category_products_bloc.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryProductsBloc>(
      lazy: false,
      create: (context) => getIt<CategoryProductsBloc>()..add(FetchCategoryProductsEvent(id: category.id)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(category.image),
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
                                    state.fetchCategoryProducts!.products![index].image!,
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
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 30,),
                                    Text(
                                      'السعر: ${state.fetchCategoryProducts!.products![index].price!}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
}
