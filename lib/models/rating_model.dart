class RatingModel {
  final int id;
  final int rideId;
  final int rating;
  final String review;
  final String fullName;
  final String profilePhoto;
  final String createdAt;

  RatingModel({
    required this.id,
    required this.rideId,
    required this.rating,
    required this.review,
    required this.fullName,
    required this.profilePhoto,
    required this.createdAt,
  });

  factory RatingModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RatingModel(
      id: int.parse(json['id'].toString()),
      rideId: int.parse(json['ride_id'].toString()),
      rating: int.parse(json['rating'].toString()),
      review: json['review'] ?? '',
      fullName: json['full_name'] ?? '',
      profilePhoto: json['profile_photo'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}