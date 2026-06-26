class ProfileModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String userType;
  final String profilePhoto;
  final String city;
  final String address;

  final double rating;
  final int totalRatings;
  final int totalRides;

  final int cancellationCount;
  final int noShowCount;

  final bool isVerified;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.userType,
    required this.profilePhoto,
    required this.city,
    required this.address,
    required this.rating,
    required this.totalRatings,
    required this.totalRides,
    required this.cancellationCount,
    required this.noShowCount,
    required this.isVerified,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: int.parse(json['id'].toString()),
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      userType: json['user_type'] ?? '',
      profilePhoto: json['profile_photo']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      rating: double.parse(json['rating'].toString()),
      totalRatings: int.parse(json['total_ratings'].toString()),
      totalRides: int.parse(json['total_rides'].toString()),
      cancellationCount: int.parse(json['cancellation_count'].toString()),
      noShowCount: int.parse(json['no_show_count'].toString()),
      isVerified: json['is_verified'].toString() == '1',
    );
  }
}
