import 'dart:async';

import 'package:flutter_admin_dashboard/features/category_products/presentation/manager/bloc/category_products_bloc.dart';
import 'package:flutter_admin_dashboard/features/wallet/data/models/wallet_model.dart';
import 'package:flutter_admin_dashboard/features/wallet/domain/use_cases/fetch_used_unused_cards_use_case.dart';
import 'package:flutter_admin_dashboard/features/wallet/domain/use_cases/generate_cards_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

@injectable
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final FetchUsedUnusedCardsUseCase fetchUsedUnusedCardsUseCase;
  final GenerateCardsUseCase generateCardsUseCase;

  WalletBloc(
    this.fetchUsedUnusedCardsUseCase,
    this.generateCardsUseCase,
  ) : super(WalletState()) {
    on<GenerateCardsEvent>(_generateCards);
    on<FetchCardsEvent>(_fetchCards);
  }

  FutureOr<void> _generateCards(GenerateCardsEvent event, Emitter emit) async {
    emit(state.copyWith(generateCardsStatus: BLocStatus.loading));
    final res = await generateCardsUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(generateCardsStatus: BLocStatus.error, errorMessage: l.message));
    }, (r) {
      emit(state.copyWith(generateCardsStatus: BLocStatus.success, generateCards: r));
    });
  }

  FutureOr<void> _fetchCards(FetchCardsEvent event, Emitter emit) async {
    emit(state.copyWith(fetchCardsStatus: BLocStatus.loading));
    final res = await fetchUsedUnusedCardsUseCase(event.isUsed);
    res.fold((l) {
      emit(state.copyWith(fetchCardsStatus: BLocStatus.error, errorMessage: l.message));
    }, (r) {
      emit(state.copyWith(fetchCardsStatus: BLocStatus.success, fetchCards: r));
    });
  }
}
