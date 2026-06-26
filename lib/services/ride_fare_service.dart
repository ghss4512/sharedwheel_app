import '../models/admin/ride_fare_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';

class RideFareService {
  final ApiService api = ApiService();

  /// Get all ride fares (Admin)
  Future<List<RideFareModel>> getRideFares() async {
    final response = await api.get(endpoint: ApiEndpoints.rideFares);

    if (response['success'] == true) {
      return (response['ride_fares'] as List)
          .map((e) => RideFareModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// Add / Update Ride Fare
  Future<Map<String, dynamic>> saveRideFare({
    int? id,
    required int fromCityId,
    required int toCityId,
    required double farePerSeat,
    bool isActive = true,
  }) async {

    return await api.post(
      endpoint: ApiEndpoints.saveRideFare,
      data: {
        'id': id,
        'from_city_id': fromCityId,
        'to_city_id': toCityId,
        'fare_per_seat': farePerSeat,
        'is_active': isActive ? 1 : 0,
      },
    );
  }

  /// Delete Ride Fare
  Future<Map<String, dynamic>> deleteRideFare({required int id}) async {
    return await api.post(
      endpoint: ApiEndpoints.deleteRideFare,
      data: {'id': id},
    );
  }

  /// Enable / Disable Ride Fare
  Future<Map<String, dynamic>> toggleRideFareStatus({required int id}) async {
    return await api.post(
      endpoint: ApiEndpoints.toggleRideFareStatus,
      data: {'id': id},
    );
  }

  /// Get fare for selected route (Driver)
  Future<Map<String, dynamic>> getRideFare({
    required int fromCityId,
    required int toCityId,
  }) async {
    return await api.get(
      endpoint:
          '${ApiEndpoints.getRideFare}?from_city_id=$fromCityId&to_city_id=$toCityId',
    );
  }
}
