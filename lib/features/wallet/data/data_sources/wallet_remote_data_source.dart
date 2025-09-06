import 'package:flutter_admin_dashboard/common/api_handler.dart';
import 'package:flutter_admin_dashboard/common/dio_helper.dart';
import 'package:flutter_admin_dashboard/features/wallet/data/models/wallet_model.dart';
import 'package:flutter_admin_dashboard/features/wallet/domain/use_cases/generate_cards_use_case.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WalletRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  WalletRemoteDataSource({required this.dioNetwork});

  Future<WalletModel> generateCards(WalletParams params) {
    return wrapHandlingApi(tryCall: () => dioNetwork.postData(endPoint: '/vouchers', data: params.getBody()), jsonConvert: walletModelFromJson);
  }

  Future<WalletModel> fetchUsedUnusedCards(bool params) {
    return wrapHandlingApi(
        tryCall: () => dioNetwork.getData(endPoint: params ? '/vouchers/used' : '/vouchers/unused'), jsonConvert: walletModelFromJson);
  }
}
