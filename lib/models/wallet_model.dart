class WalletModel {
  final double balance;

  WalletModel({required this.balance});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: double.tryParse(json['balance'].toString()) ?? 0,
    );
  }
}
