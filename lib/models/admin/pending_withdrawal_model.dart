class PendingWithdrawalModel {
  final int id;
  final int userId;
  final String fullName;
  final String phone;
  final String method;
  final String accountTitle;
  final String accountNumber;
  final double amount;
  final String remarks;
  final String status;
  final String createdAt;

  PendingWithdrawalModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.method,
    required this.accountTitle,
    required this.accountNumber,
    required this.amount,
    required this.remarks,
    required this.status,
    required this.createdAt,
  });

  factory PendingWithdrawalModel.fromJson(Map<String, dynamic> json) {
    return PendingWithdrawalModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      method: json['method'] ?? '',
      accountTitle: json['account_title'] ?? '',
      accountNumber: json['account_number'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      remarks: json['remarks'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}