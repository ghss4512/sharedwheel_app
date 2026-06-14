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
  static const String rejectBooking = '/bookings/reject_booking.php';
  static const String updateBookingStatus = '/bookings/update_booking_status.php';
  static const String markRemainingNoShows = '/bookings/mark_remaining_no_shows.php';

  // Wallet
  static const String getWallet = '/wallet/get_wallet.php';
  static const String getWalletTransactions = '/wallet/get_wallet_transactions.php';
}
