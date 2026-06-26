class MessageModel {
  final int id;
  final int rideId;
  final int senderId;
  final int receiverId;
  final String message;
  final bool isRead;
  final String createdAt;

  final String senderName;
  final String senderPhoto;

  MessageModel({
    required this.id,
    required this.rideId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.senderName,
    required this.senderPhoto,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: int.parse(json['id'].toString()),
      rideId: int.parse(json['ride_id'].toString()),
      senderId: int.parse(json['sender_id'].toString()),
      receiverId: int.parse(json['receiver_id'].toString()),
      message: json['message'] ?? '',
      isRead: json['is_read'].toString() == '1',
      createdAt: json['created_at'] ?? '',
      senderName: json['sender_name'] ?? '',
      senderPhoto: json['sender_photo'] ?? '',
    );
  }
}
