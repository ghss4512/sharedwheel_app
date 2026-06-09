class ApiEndpoints {
  // Authentication
  static const String login = '/auth/login.php';
  static const String register = '/auth/register.php';

  //Settings
  static const String getSetting = '/settings/get_setting.php';

  // Rides
  static const String searchRides = '/rides/search.php';
  static const String rideDetails = '/rides/ride_details.php';
  static const String myRides = '/rides/my_rides.php';
  static const String postRide = '/rides/post_ride.php';
  static const String ridePassengers = '/rides/ride_passengers.php';
  static const String updateRideStatus = '/rides/update_ride_status.php';

  // Bookings
  static const String bookRide = '/bookings/book.php';
  static const String myBookings = '/bookings/my_bookings.php';
  static const String rideRequests = '/bookings/ride_requests.php';
  static const String approveBooking = '/bookings/approve_booking.php';
  static const String rejectBooking = '/bookings/reject_booking.php';
  static const String updateBookingStatus = '/bookings/update_booking_status.php';

  // Wallet
  static const String wallet = '/wallet/index.php';
}
