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

  Future<String> getSetting(String key, String defaultValue) async {
    try {
      final result = await api.get(
        endpoint: ApiEndpoints.getSetting,
        queryParameters: {'key': key},
      );

      if (result['success'] == true) {
        return result['value']?.toString() ?? defaultValue;
      }
    } catch (_) {}

    return defaultValue;
  }
}
