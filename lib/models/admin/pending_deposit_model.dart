class PendingDepositModel {
  final int id;
  final int userId;
  final String fullName;
  final String phone;
  final double amount;
  final String description;
  final String status;
  final String createdAt;

  PendingDepositModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.amount,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory PendingDepositModel.fromJson(Map<String, dynamic> json) {
    return PendingDepositModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
