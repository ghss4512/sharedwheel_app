class WithdrawalRequestModel {
  final int id;
  final String method;
  final String accountTitle;
  final String accountNumber;
  final double amount;
  final String remarks;
  final String status;
  final String createdAt;

  WithdrawalRequestModel({
    required this.id,
    required this.method,
    required this.accountTitle,
    required this.accountNumber,
    required this.amount,
    required this.remarks,
    required this.status,
    required this.createdAt,
  });

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequestModel(
      id: int.parse(json['id'].toString()),
      method: json['method'] ?? '',
      accountTitle: json['account_title'] ?? '',
      accountNumber: json['account_number'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      remarks: json['remarks'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }
}