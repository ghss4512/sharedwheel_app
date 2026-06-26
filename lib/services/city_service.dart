import '../models/city_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';

class CityService {
  final ApiService api = ApiService();

  /// Get all cities (Admin)
  Future<List<CityModel>> getCities() async {
    final result = await api.get(endpoint: ApiEndpoints.cities);

    if (result['success'] != true) {
      return [];
    }

    return (result['cities'] as List)
        .map((e) => CityModel.fromJson(e))
        .toList();
  }

  /// Get active cities (Dropdowns)
  Future<List<CityModel>> getActiveCities() async {
    final result = await api.get(endpoint: ApiEndpoints.activeCities);

    if (result['success'] != true) {
      return [];
    }

    return (result['cities'] as List)
        .map((e) => CityModel.fromJson(e))
        .toList();
  }

  /// Add / Update City
  Future<Map<String, dynamic>> saveCity({
    int? id,
    required String cityName,
    required String province,
    double? latitude,
    double? longitude,
    required bool isActive,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.saveCity,
      data: {
        'id': id?.toString() ?? '',
        'city_name': cityName,
        'province': province,
        'latitude': latitude?.toString() ?? '',
        'longitude': longitude?.toString() ?? '',
        'is_active': isActive ? '1' : '0',
      },
    );
  }

  /// Delete City
  Future<Map<String, dynamic>> deleteCity({required int id}) async {
    return await api.post(
      endpoint: ApiEndpoints.deleteCity,
      data: {'id': id.toString()},
    );
  }

  /// Activate / Deactivate City
  Future<Map<String, dynamic>> toggleCityStatus({required int id}) async {
    return await api.post(
      endpoint: ApiEndpoints.toggleCityStatus,
      data: {'id': id.toString()},
    );
  }
}
