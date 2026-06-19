
import '../models/notification_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';

class NotificationService {
  final ApiService api = ApiService();

  Future<List<NotificationModel>> getNotifications() async {
    if (AppSession.userId == null) {
      return [];
    }

    final result = await api.get(
      endpoint: ApiEndpoints.getNotifications,
      queryParameters: {'user_id': AppSession.userId.toString()},
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['notifications'] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  Future<int> getUnreadCount() async {
    if (AppSession.userId == null) {
      return 0;
    }

    final result = await api.get(
      endpoint: ApiEndpoints.unreadNotificationCount,
      queryParameters: {'user_id': AppSession.userId.toString()},
    );
    if (result['success'] != true) {
      return 0;
    }

    return int.parse(result['count'].toString());
  }

  Future<void> markRead(int notificationId) async {
    await api.post(
      endpoint: ApiEndpoints.markNotificationRead,
      data: {'notification_id': notificationId.toString()},
    );
  }
}
