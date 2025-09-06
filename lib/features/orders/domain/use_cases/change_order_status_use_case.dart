import 'package:flutter_admin_dashboard/common/common_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/typedef.dart';
import '../repositories/orders_repo.dart';

@lazySingleton
class ChangeOrderStatusUseCase implements UseCase<CommonModel, int> {

  final OrdersRepo ordersRepo;

  ChangeOrderStatusUseCase({required this.ordersRepo});

  @override
  DataResponse<CommonModel> call(int params) {
    return ordersRepo.changeOrderStatus(params);
  }
}