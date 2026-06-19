class WalletTransactionModel {
  final int id;
  final String transactionType;
  final double amount;
  final String referenceType;
  final int? referenceId;
  final String description;
  final String status;
  final String createdAt;

  WalletTransactionModel({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.referenceType,
    required this.referenceId,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: int.parse(json['id'].toString()),
      transactionType: json['transaction_type'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      referenceType: json['reference_type'] ?? '',
      referenceId: json['reference_id'] == null
          ? null
          : int.tryParse(json['reference_id'].toString()),
      description: json['description'] ?? '',
      status: json['status'] ?? 'approved',
      createdAt: json['created_at'] ?? '',
    );
  }
}