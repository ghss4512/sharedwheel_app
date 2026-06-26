import '../models/passenger_completed_ride_model.dart';
import '../models/ride_model.dart';
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
      endpoint:
          '${ApiEndpoints.completedBookingsCount}?passenger_id=${AppSession.userId}',
    );

    if (result['success'] == true) {
      return int.tryParse(result['count'].toString()) ?? 0;
    }

    return 0;
  }

  Future<List<RideModel>> getActiveRides() async {
    final result = await api.get(
      endpoint: ApiEndpoints.passengerActiveRides,
      queryParameters: {'user_id': AppSession.userId.toString()},
    );
    if (result['success'] != true) {
      return [];
    }
    return (result['rides'] as List).map((e) => RideModel.fromJson(e)).toList();
  }

  Future<RideModel?> getActiveRide() async {
    final rides = await getActiveRides();

    if (rides.isEmpty) {
      return null;
    }

    return rides.first;
  }

  Future<RideModel?> getRecentRide() async {
    final result = await api.get(
      endpoint: ApiEndpoints.myBookings,
      queryParameters: {'user_id': AppSession.userId.toString()},
    );

    if (result['success'] != true) {
      return null;
    }

    final rides = (result['bookings'] as List);

    if (rides.isEmpty) {
      return null;
    }

    return RideModel.fromJson(rides.first);
  }

  Future<List<RideModel>> getCompletedRides() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.passengerCompletedRides}?passenger_id=${AppSession.userId}',
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['rides'] as List).map((e) => RideModel.fromJson(e)).toList();
  }

  Future<PassengerCompletedRideModel?> getCompletedRideDetails({
    required int rideId,
  }) async {
    final result = await api.get(
      endpoint: ApiEndpoints.completedRideDetails,
      queryParameters: {
        'ride_id': rideId.toString(),
        'passenger_id': AppSession.userId.toString(),
      },
    );

    if (result['success'] != true) {
      return null;
    }

    return PassengerCompletedRideModel.fromJson(result['ride']);
  }
}
