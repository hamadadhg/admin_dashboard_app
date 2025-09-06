import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/wallet/data/models/wallet_model.dart';

import '../use_cases/generate_cards_use_case.dart';

abstract class WalletRepo {

  DataResponse<WalletModel> generateCards(WalletParams params);
  DataResponse<WalletModel> fetchUsedUnused(bool isUsed);

}