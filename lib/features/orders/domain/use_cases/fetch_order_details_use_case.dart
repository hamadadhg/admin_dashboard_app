import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/orders_model.dart';
import '../repositories/orders_repo.dart';

@lazySingleton
class FetchOrderDetailsUseCase implements UseCase<OrdersModel, int> {

  final OrdersRepo ordersRepo;

  FetchOrderDetailsUseCase({required this.ordersRepo});

  @override
  DataResponse<OrdersModel> call(int params) {
    return ordersRepo.fetchOrderDetails(params);
  }
}