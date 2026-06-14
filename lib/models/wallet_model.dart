class WalletModel {
  final int id;
  final int userId;
  final double balance;
  final String createdAt;
  final String updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      balance: double.parse(json['balance'].toString()),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}