import '../utils/api_endpoints.dart';
import 'api_service.dart';

class SettingsService {
  final ApiService api = ApiService();

  Future<int> getDriverWaitingTime() async {
    final result = await api.get(
      endpoint: ApiEndpoints.getSetting,
      queryParameters: {'key': 'driver_waiting_time'},
    );

    if (result['success'] != true) {
      return 30;
    }

    return int.tryParse(result['value'].toString()) ?? 30;
  }
}