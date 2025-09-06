WalletModel walletModelFromJson(str) => WalletModel.fromJson(str);

class WalletModel {
  List<Voucher>? vouchers;

  WalletModel({this.vouchers});

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        vouchers: json['vouchers'] == null ? [] : List<Voucher>.from(json['vouchers'].map((v) => Voucher.fromJson(v))),
      );
}

class Voucher {
  String? code;
  String? amount;

  Voucher({this.code, this.amount});

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        code: json['code'],
        amount: json['amount'],
      );
}
