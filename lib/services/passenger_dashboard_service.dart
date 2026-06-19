import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';
import 'api_service.dart';

class PassengerDashboardService {
  final ApiService api = ApiService();

  Future<int> getPassengerBookingsCount() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.passengerBookingsCount}?passenger_id=${AppSession.userId}',
    );

    if (result['success'] == true) {
      return int.tryParse(result['count'].toString()) ?? 0;
    }

    return 0;
  }

  Future<int> getActiveBookingsCount() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.activeBookingsCount}?passenger_id=${AppSession.userId}',
    );

    if (result['success'] == true) {
      return int.tryParse(result['count'].toString()) ?? 0;
    }

    return 0;
  }

  Future<int> getCompletedBookingsCount() async {
    final result = await api.get(
      endpoint: '${ApiEndpoints.completedBookingsCount}?passenger_id=${AppSession.userId}',
    );

    if (result['success'] == true) {
      return int.tryParse(result['count'].toString()) ?? 0;
    }

    return 0;
  }
}
