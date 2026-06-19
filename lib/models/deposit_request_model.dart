class DepositRequestModel {
  final int id;
  final double amount;
  final String description;
  final String status;
  final String createdAt;

  DepositRequestModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory DepositRequestModel.fromJson(Map<String, dynamic> json) {
    return DepositRequestModel(
      id: int.parse(json['id'].toString()),
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }
}