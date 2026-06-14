class WalletTransactionModel {
  final int id;
  final String transactionType;
  final double amount;
  final String description;
  final String createdAt;

  WalletTransactionModel({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: int.parse(json['id'].toString()),
      transactionType: json['transaction_type'] ?? '',
      amount: double.parse(json['amount'].toString()),
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
