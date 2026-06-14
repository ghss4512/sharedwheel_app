import '../models/booking_request_model.dart';
import '../utils/api_endpoints.dart';
import 'api_service.dart';
import '../utils/app_session.dart';
import '../models/booking_model.dart';

class BookingService {
  final ApiService api = ApiService();

  Future<dynamic> bookRide({
    required int rideId,
    required int passengerId,
    required int seatsBooked,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.bookRide,
      data: {
        'ride_id': rideId.toString(),
        'passenger_id': passengerId.toString(),
        'seats_booked': seatsBooked.toString(),
      },
    );
  }

  Future<List<BookingModel>> getMyBookings() async {
    final result = await api.get(
      endpoint: ApiEndpoints.myBookings,
      queryParameters: {'passenger_id': AppSession.userId.toString()},
    );
    if (result['success'] != true) {
      return [];
    }
    return (result['bookings'] as List)
        .map((booking) => BookingModel.fromJson(booking))
        .toList();
  }

  Future<List<BookingRequestModel>> getRideRequests() async {
    final result = await api.get(
      endpoint: ApiEndpoints.rideRequests,
      queryParameters: {'driver_id': AppSession.userId.toString()},
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['requests'] as List)
        .map((request) => BookingRequestModel.fromJson(request))
        .toList();
  }

  Future<dynamic> rejectBooking(int bookingId) async {
    return await api.post(
      endpoint: ApiEndpoints.rejectBooking,

      data: {'booking_id': bookingId.toString()},
    );
  }

  Future<dynamic> updateBookingStatus({required int bookingId, required String status,}) async {
    return await api.post(
      endpoint: ApiEndpoints.updateBookingStatus,
      data: {'booking_id': bookingId.toString(), 'status': status},
    );
  }

  Future<dynamic> markRemainingNoShows(int rideId) async {
    return await api.post(
      endpoint: ApiEndpoints.markRemainingNoShows,
      data: {'ride_id': rideId.toString()},
    );
  }
}
