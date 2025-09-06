import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../category_products/presentation/manager/bloc/category_products_bloc.dart';
import '../manager/bloc/orders_bloc.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> titles = {
      "pending": "قيد الانتظار",
      "in_delivery": "في التوصيل",
      "completed": "مكتمل",
      "confirmed": "مؤكد",
      "canceled": "ملغي",
    };

    return BlocProvider<OrdersBloc>(
      lazy: false,
      create: (context) => getIt<OrdersBloc>()..add(FetchOrdersEvent(status: 'pending')),
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  return Row(
                    spacing: 20,
                    children: List.generate(
                        5,
                        (i) => Expanded(
                              child: InkWell(
                                onTap: () {
                                  context.read<OrdersBloc>().add(FetchOrdersEvent(status: titles.keys.toList()[i]));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.purpleAccent),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
                                  child: Center(
                                    child: Text(
                                      titles.values.toList()[i],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  );
                },
              ),
            ),
            Expanded(child: BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                switch (state.fetchOrdersStatus) {
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
                    if (state.fetchOrders!.orders!.isEmpty) {
                      return const Center(
                        child: Text('لا يوجد طلبات'),
                      );
                    }
                    return ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.fetchOrders!.orders![index].username!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      state.fetchOrders!.orders![index].orderType!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Text(
                                  'السعر: ${state.fetchOrders!.orders![index].price!}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      itemCount: state.fetchOrders!.orders!.length,
                    );
                  case BLocStatus.error:
                    return Center(
                      child: Text(state.errorMessage!),
                    );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
