class ApiEndpoints {

  // Authentication
  static const String login = '/auth/login.php';
  static const String register = '/auth/register.php';

  // Rides
  static const String searchRides = '/rides/search.php';
  static const String rideDetails = '/rides/details.php';
  static const String myRides = '/rides/my_rides.php';
  static const String postRide = '/rides/post_ride.php';

  // Bookings
  static const String bookRide = '/bookings/book.php';
  static const String myBookings = '/bookings/my_bookings.php';
  static const String rideRequests ='/bookings/ride_requests.php';
  static const String approveBooking = '/bookings/approve_booking.php';
  static const String rejectBooking = '/bookings/reject_booking.php';

  // Wallet
  static const String wallet = '/wallet/index.php';

}