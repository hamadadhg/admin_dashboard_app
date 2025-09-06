part of 'wallet_bloc.dart';

class WalletState {
  String? errorMessage;
  BLocStatus? generateCardsStatus;
  BLocStatus? fetchCardsStatus;
  WalletModel? generateCards;
  WalletModel? fetchCards;

  WalletState({
    this.generateCards,
    this.errorMessage,
    this.fetchCards,
    this.fetchCardsStatus,
    this.generateCardsStatus,
  });

  WalletState copyWith({
    String? errorMessage,
    BLocStatus? generateCardsStatus,
    BLocStatus? fetchCardsStatus,
    WalletModel? generateCards,
    WalletModel? fetchCards,
  }) =>
      WalletState(
        errorMessage: errorMessage ?? this.errorMessage,
        generateCards: generateCards ?? this.generateCards,
        generateCardsStatus: generateCardsStatus ?? this.generateCardsStatus,
        fetchCards: fetchCards ?? this.fetchCards,
        fetchCardsStatus: fetchCardsStatus ?? this.fetchCardsStatus,
      );
}
