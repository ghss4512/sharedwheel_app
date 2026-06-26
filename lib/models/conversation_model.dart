class ConversationModel {
  final int rideId;
  final int otherUserId;

  final String fullName;
  final String profilePhoto;

  final String lastMessage;
  final String createdAt;

  final int unreadCount;

  ConversationModel({
    required this.rideId,
    required this.otherUserId,
    required this.fullName,
    required this.profilePhoto,
    required this.lastMessage,
    required this.createdAt,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      rideId: int.parse(json['ride_id'].toString()),
      otherUserId: int.parse(json['other_user_id'].toString()),
      fullName: json['full_name'] ?? '',
      profilePhoto: json['profile_photo'] ?? '',
      lastMessage: json['last_message'] ?? '',
      createdAt: json['created_at'] ?? '',
      unreadCount: int.parse(json['unread_count'].toString()),
    );
  }
}
