class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String userType;
  final String city;
  final String profilePhoto;
  final String status;
  final bool isVerified;
  final bool isActive;
  final double rating;
  final int totalRatings;
  final int totalRides;
  final double walletBalance;
  final int noShowCount;
  final int cancellationCount;
  final String address;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.city,
    required this.profilePhoto,
    required this.status,
    required this.isVerified,
    required this.isActive,
    required this.rating,
    required this.totalRatings,
    required this.totalRides,
    required this.walletBalance,
    required this.noShowCount,
    required this.cancellationCount,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id'].toString()),
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['user_type'] ?? '',
      city: json['city'] ?? '',
      profilePhoto: json['profile_photo'] ?? '',
      status: json['status'] ?? 'active',
      isVerified: json['is_verified'].toString() == '1',
      isActive: json['is_active'].toString() == '1',
      rating: double.tryParse(json['rating'].toString()) ?? 0,
      totalRatings: int.tryParse(json['total_ratings'].toString()) ?? 0,
      totalRides: int.tryParse(json['total_rides'].toString()) ?? 0,
      walletBalance: double.tryParse(json['wallet_balance'].toString()) ?? 0,
      noShowCount: int.tryParse(json['no_show_count'].toString()) ?? 0,
      cancellationCount: int.tryParse(json['cancellation_count'].toString()) ?? 0,
      address: json['address'] ?? '',
    );
  }
}
