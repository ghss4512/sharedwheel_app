import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';
import 'api_service.dart';
import '../models/ride_model.dart';
import '../models/passenger_model.dart';

class RideService {
  final ApiService api = ApiService();

  Future<List<RideModel>> searchRides({String? fromCity, String? toCity,}) async {
    final result = await api.get(
      endpoint: ApiEndpoints.searchRides,
      queryParameters: {'from_city': ?fromCity, 'to_city': ?toCity},
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }

  Future<List<RideModel>> getAvailableRides() async {
    final result = await api.get(endpoint: ApiEndpoints.searchRides);

    if (result['success'] != true) {
      return [];
    }

    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }

  Future<List<RideModel>> getMyRides() async {
    final result = await api.get(
      endpoint: ApiEndpoints.myRides,
      queryParameters: {'driver_id': AppSession.userId.toString()},
    );
    if (result['success'] != true) {
      return [];
    }
    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }

  Future<dynamic> postRide({
    required String fromCity,
    required String toCity,
    required String travelDate,
    required String travelTime,
    required int totalSeats,
    required double farePerSeat,
    required String vehicleName,
    required String vehicleNumber,
    required String vehicleColor,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.postRide,
      data: {
        'driver_id': AppSession.userId.toString(),
        'from_city': fromCity,
        'to_city': toCity,
        'travel_date': travelDate,
        'travel_time': travelTime,
        'total_seats': totalSeats.toString(),
        'fare_per_seat': farePerSeat.toString(),
        'vehicle_name': vehicleName,
        'vehicle_number': vehicleNumber,
        'vehicle_color': vehicleColor,
      },
    );
  }

  Future<List<PassengerModel>> getRidePassengers(int rideId) async {
    final result = await api.get(
      endpoint: ApiEndpoints.ridePassengers,
      queryParameters: {'ride_id': rideId.toString()},
    );
    if (result['success'] != true) {
      return [];
    }
    return (result['passengers'] as List)
        .map((passenger) => PassengerModel.fromJson(passenger))
        .toList();
  }

  Future<dynamic> updateRideStatus({required int rideId, required String status,}) async {
    return await api.post(
      endpoint: ApiEndpoints.updateRideStatus,
      data: {'ride_id': rideId.toString(), 'status': status},
    );
  }

  Future<RideModel?> getRideDetails(int rideId) async {
    final result = await api.get(
      endpoint: ApiEndpoints.rideDetails,
      queryParameters: {'ride_id': rideId.toString()},
    );

    if (result['success'] != true) {
      return null;
    }

    return RideModel.fromJson(result['ride']);
  }
}
