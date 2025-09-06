import 'package:flutter_admin_dashboard/common/error_handeler.dart';
import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/wallet/data/data_sources/wallet_remote_data_source.dart';
import 'package:flutter_admin_dashboard/features/wallet/data/models/wallet_model.dart';
import 'package:flutter_admin_dashboard/features/wallet/domain/repositories/wallet_repo.dart';
import 'package:flutter_admin_dashboard/features/wallet/domain/use_cases/generate_cards_use_case.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: WalletRepo)
class WalletRepoImpl with HandlingException implements WalletRepo {
  final WalletRemoteDataSource walletRemoteDataSource;

  WalletRepoImpl({required this.walletRemoteDataSource});

  @override
  DataResponse<WalletModel> fetchUsedUnused(bool isUsed) {
    return wrapHandlingException(tryCall: () => walletRemoteDataSource.fetchUsedUnusedCards(isUsed));
  }

  @override
  DataResponse<WalletModel> generateCards(WalletParams params) {
    return wrapHandlingException(tryCall: () => walletRemoteDataSource.generateCards(params));
  }
}
