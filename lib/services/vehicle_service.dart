
import '../../models/vehicle_model.dart';
import '../../services/api_service.dart';
import '../../utils/api_endpoints.dart';
import '../../utils/app_session.dart';

class VehicleService {
  final ApiService api = ApiService();

  Future<List<VehicleModel>> getVehicles() async {
    final result = await api.get(
      endpoint: '${ApiEndpoints.getVehicles}?driver_id=${AppSession.userId}',
    );
    if (result['success'] != true) {
      return [];
    }

    return (result['vehicles'] as List)
        .map((e) => VehicleModel.fromJson(e))
        .toList();
  }

  Future<dynamic> setDefaultVehicle(int vehicleId) async {
    return await api.post(
      endpoint: ApiEndpoints.setDefaultVehicle,
      data: {
        'vehicle_id': vehicleId.toString(),
        'driver_id': AppSession.userId.toString(),
      },
    );
  }

  Future<dynamic> addVehicle({
    required String vehicleType,
    required String vehicleName,
    required String vehicleNumber,
    required String vehicleColor,
    required int seatingCapacity,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.addVehicle,
      data: {
        'driver_id': AppSession.userId.toString(),
        'vehicle_type': vehicleType,
        'vehicle_name': vehicleName,
        'vehicle_number': vehicleNumber,
        'vehicle_color': vehicleColor,
        'seating_capacity': seatingCapacity.toString(),
      },
    );
  }

  Future<dynamic> deleteVehicle(int vehicleId) async {
    return await api.post(
      endpoint: ApiEndpoints.deleteVehicle,
      data: {
        'vehicle_id': vehicleId.toString(),
        'driver_id': AppSession.userId.toString(),
      },
    );
  }

  Future<dynamic> updateVehicle({
    required int vehicleId,
    required String vehicleType,
    required String vehicleName,
    required String vehicleNumber,
    required String vehicleColor,
    required int seatingCapacity,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.updateVehicle,
      data: {
        'vehicle_id': vehicleId.toString(),
        'driver_id': AppSession.userId.toString(),
        'vehicle_type': vehicleType,
        'vehicle_name': vehicleName,
        'vehicle_number': vehicleNumber,
        'vehicle_color': vehicleColor,
        'seating_capacity': seatingCapacity.toString(),
      },
    );
  }

  Future<VehicleModel?> getDefaultVehicle() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.getDefaultVehicle}?driver_id=${AppSession.userId}',
    );
    if (result['success'] != true) {
      return null;
    }
    return VehicleModel.fromJson(result['vehicle']);
  }

  Future<int> getVehicleCount() async {
    final result = await api.get(
      endpoint: '${ApiEndpoints.vehicleCount}?driver_id=${AppSession.userId}',
    );
    if (result['success'] == true) {
      return result['count'] ?? 0;
    }
    return 0;
  }
}
