class UserModel {
  final int id;
  final String fullName;
  final String phone;
  final String email;
  final String userType;
  final String userStatus;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.userType,
    required this.userStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(
        json['id'].toString(),
      ),
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      userType: json['user_type'] ?? '',
      userStatus: json['status'] ?? '',
    );
  }
}