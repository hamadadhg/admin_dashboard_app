import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/wallet/data/models/wallet_model.dart';
import 'package:flutter_admin_dashboard/features/wallet/domain/repositories/wallet_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchUsedUnusedCardsUseCase implements UseCase<WalletModel, bool> {

  final WalletRepo walletRepo;

  FetchUsedUnusedCardsUseCase({required this.walletRepo});

  @override
  DataResponse<WalletModel> call(bool params) {
    return walletRepo.fetchUsedUnused(params);
  }
}