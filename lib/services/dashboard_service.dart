import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';
import 'api_service.dart';

class DashboardService {
  final ApiService api = ApiService();

  Future<int> getPendingRequestsCount() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.pendingRequestsCount}?driver_id=${AppSession.userId}',
    );

    return result['count'] ?? 0;
  }

  Future<int> getActiveRidesCount() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.activeRidesCount}?driver_id=${AppSession.userId}',
    );

    return result['count'] ?? 0;
  }

  Future<int> getCompletedRidesCount() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.completedRidesCount}?driver_id=${AppSession.userId}',
    );

    return result['count'] ?? 0;
  }

  Future<Map<String, dynamic>?> getUpcomingRide() async {
    final result = await api.get(
      endpoint: '/dashboard/upcoming_ride.php?driver_id=${AppSession.userId}',
    );

    if (result['success'] != true) {
      return null;
    }

    return result['ride'];
  }
}
