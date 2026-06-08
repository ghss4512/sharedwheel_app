import '../utils/api_endpoints.dart';
import 'api_service.dart';
import '../utils/app_session.dart';
import '../models/booking_model.dart';
class BookingService {
  final ApiService api = ApiService();

  Future<dynamic> bookRide({required int rideId, required int passengerId, required int seatsBooked,}) async {
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
      queryParameters: { 'passenger_id': AppSession.userId.toString(), },
    );
    if (result['success'] != true) {
      return [];
    }
    return (result['bookings'] as List).map((booking) => BookingModel.fromJson(booking),).toList();
  }
}