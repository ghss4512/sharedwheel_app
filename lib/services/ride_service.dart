import 'package:flutter/cupertino.dart';

import '../models/passenger_model.dart';
import '../models/ride_model.dart';
import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';
import 'api_service.dart';

class RideService {
  final ApiService api = ApiService();

  Future<List<RideModel>> searchRides({
    int? fromCityId,
    int? toCityId,
    DateTime? travelDate,
  }) async {
    final result = await api.get(
      endpoint: ApiEndpoints.searchRides,
      queryParameters: {
        'from_city_id': fromCityId,
        'to_city_id': toCityId,
        'travelDate' : travelDate,
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
    required int vehicleId,
    required int fromCityId,
    required int toCityId,
    required String pickupLocation,
    required String dropLocation,
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
        'vehicle_id': vehicleId,
        'from_city_id': fromCityId,
        'to_city_id': toCityId,
        'driver_id': AppSession.userId.toString(),
        'pickup_location': pickupLocation,
        'drop_location': dropLocation,
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

  Future<List<PassengerModel>> getRidePassengers(
    int rideId,
    int driverId,
  ) async {
    //  Future<List<PassengerModel>> getRidePassengers(int rideId) async {
    final result = await api.get(
      endpoint: ApiEndpoints.ridePassengers,
      // queryParameters: {'ride_id'   : rideId.toString(),},
      queryParameters: {
        'ride_id': rideId.toString(),
        'driver_id': driverId.toString(),
      },
    );
    if (result['success'] != true) {
      return [];
    }
    return (result['passengers'] as List)
        .map((passenger) => PassengerModel.fromJson(passenger))
        .toList();
  }

  Future<dynamic> updateRideStatus({
    required int rideId,
    required String status,
  }) async {
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

    debugPrint(result.toString());
    debugPrint(result['ride'].toString());

    if (result['success'] != true) {
      return null;
    }

    return RideModel.fromJson(result['ride']);
  }

  Future<List<RideModel>> getCompletedRides() async {
    final result = await api.get(
      endpoint: '${ApiEndpoints.completedRides}?driver_id=${AppSession.userId}',
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['rides'] as List).map((e) => RideModel.fromJson(e)).toList();
  }

  Future<List<RideModel>> getActiveRides() async {
    final rides = await getMyRides();
    return rides
        .where(
          (ride) =>
              ride.rideStatus.toLowerCase() == 'scheduled' ||
              ride.rideStatus.toLowerCase() == 'enroute' ||
              ride.rideStatus.toLowerCase() == 'arrived' ||
              ride.rideStatus.toLowerCase() == 'waiting' ||
              ride.rideStatus.toLowerCase() == 'in_progress',
        )
        .toList();
  }

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
