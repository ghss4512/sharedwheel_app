import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';

class MessageService {
  final ApiService api = ApiService();

  Future<Map<String, dynamic>> sendMessage({
    required int rideId,
    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.sendMessage,
      data: {
        'ride_id': rideId.toString(),
        'sender_id': senderId.toString(),
        'receiver_id': receiverId.toString(),
        'message': message,
      },
    );
  }

  Future<List<MessageModel>> getConversation({
    required int rideId,
    required int userId,
    required int otherUserId,
  }) async {
    final result = await api.get(
      endpoint: ApiEndpoints.getConversation,
      queryParameters: {
        'ride_id': rideId.toString(),
        'user_id': userId.toString(),
        'other_user_id': otherUserId.toString(),
      },
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['messages'] as List)
        .map((e) => MessageModel.fromJson(e))
        .toList();
  }

  Future<List<ConversationModel>> getConversations({
    required int userId,
  }) async {
    final result = await api.get(
      endpoint: ApiEndpoints.conversations,
      queryParameters: {'user_id': userId.toString()},
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['conversations'] as List)
        .map((e) => ConversationModel.fromJson(e))
        .toList();
  }

  Future<Map<String, dynamic>> markMessagesRead({
    required int rideId,
    required int senderId,
    required int receiverId,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.markMessagesRead,
      data: {
        'ride_id': rideId.toString(),
        'sender_id': senderId.toString(),
        'receiver_id': receiverId.toString(),
      },
    );
  }

  Future<Map<String, dynamic>> deleteMessage({
    required int messageId,
    required int userId,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.deleteMessage,
      data: {'message_id': messageId.toString(), 'user_id': userId.toString()},
    );
  }

  Future<int> getUnreadCount({required int userId}) async {
    final conversations = await getConversations(userId: userId);
    int total = 0;
    for (final conversation in conversations) {
      total += conversation.unreadCount;
    }
    return total;
  }
}
