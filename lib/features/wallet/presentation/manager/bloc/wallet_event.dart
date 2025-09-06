part of 'wallet_bloc.dart';

abstract class WalletEvent {}

class GenerateCardsEvent extends WalletEvent {
  final WalletParams params;

  GenerateCardsEvent({required this.params});
}

class FetchCardsEvent extends WalletEvent {
  final bool isUsed;

  FetchCardsEvent({required this.isUsed});
}
