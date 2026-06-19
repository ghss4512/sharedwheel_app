class PaymentSettingsModel {
  final String jazzCashNumber;
  final String easyPaisaNumber;
  final String bankName;
  final String accountTitle;
  final String accountNumber;

  PaymentSettingsModel({
    required this.jazzCashNumber,
    required this.easyPaisaNumber,
    required this.bankName,
    required this.accountTitle,
    required this.accountNumber,
  });

  factory PaymentSettingsModel.fromJson(Map<String, dynamic> json) {
    return PaymentSettingsModel(
      jazzCashNumber: json['jazzcash_number'] ?? '',
      easyPaisaNumber: json['easypaisa_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountTitle: json['account_title'] ?? '',
      accountNumber: json['account_number'] ?? '',
    );
  }
}
