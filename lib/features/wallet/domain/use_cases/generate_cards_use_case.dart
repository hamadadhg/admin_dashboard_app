import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/wallet/data/models/wallet_model.dart';
import 'package:flutter_admin_dashboard/features/wallet/domain/repositories/wallet_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GenerateCardsUseCase implements UseCase<WalletModel, WalletParams> {

  final WalletRepo walletRepo;

  GenerateCardsUseCase({required this.walletRepo});

  @override
  DataResponse<WalletModel> call(WalletParams params) {
    return walletRepo.generateCards(params);
  }
}

class WalletParams with Params{

  final String count;
  final String amount;

  WalletParams({required this.count, required this.amount});

  @override
  BodyMap getBody() =>{
    "count": count,
    "amount": amount,
  };

}