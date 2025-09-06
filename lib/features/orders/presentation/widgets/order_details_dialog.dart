import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard/core/di/injection.dart';
import 'package:flutter_admin_dashboard/features/category_products/presentation/manager/bloc/category_products_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/bloc/orders_bloc.dart';

class OrderDetailsDialog extends StatelessWidget {
  const OrderDetailsDialog({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersBloc>(
      create: (context) => getIt<OrdersBloc>()..add(FetchOrderDetailsEvent(id: id)),
      child: Dialog(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
            if (state.fetchOrderDetailsStatus == BLocStatus.success) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('username:  ${state.fetchOrderDetails!.order!.user!.username!}'),
                  Text('price:          ${state.fetchOrderDetails!.order!.price!}'),
                  Text('order type: ${state.fetchOrderDetails!.order!.orderType!}'),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
                      child: Center(
                        child: Text(state.fetchOrderDetails!.order!.user!.phone!),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state.fetchOrderDetailsStatus == BLocStatus.error) {
              return Center(
                child: Text(state.errorMessage!),
              );
            } else {
              return const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 120, vertical: 140),
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }),
        ),
      ),
    );
  }
}
