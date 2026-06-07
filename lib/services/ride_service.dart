import '../utils/api_endpoints.dart';
import 'api_service.dart';
import '../models/ride_model.dart';

class RideService {
  final ApiService api = ApiService();

  Future<List<RideModel>> searchRides({String? fromCity, String? toCity}) async {
    final result = await api.get(
      endpoint: ApiEndpoints.searchRides,
      queryParameters: {
        if (fromCity != null) 'from_city': fromCity,
        if (toCity != null) 'to_city': toCity,
      },
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }

  Future<List<RideModel>> getAvailableRides() async {

    final result = await api.get(
      endpoint: ApiEndpoints.searchRides,
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }
}