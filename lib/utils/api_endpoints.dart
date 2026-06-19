class ApiEndpoints {
  // Authentication
  static const String login = '/auth/login.php';
  static const String register = '/auth/register.php';

  // Admin Panel
  static const String dashboardStats = '/admin/dashboard_stats.php';

  static const String getPendingDeposits = '/admin/get_pending_deposits.php';
  static const String approveDeposit = '/wallet/approve_deposit.php';
  static const String rejectDeposit = '/wallet/reject_deposit.php';

  static const String depositHistory = '/admin/deposit_history.php';
  static const String withdrawalHistory = '/admin/withdrawal_history.php';

  static const String getPendingWithdrawals = '/admin/get_pending_withdrawals.php';
  static const String approveWithdrawal = '/wallet/approve_withdrawal.php';
  static const String rejectWithdrawal = '/wallet/reject_withdrawal.php';

  // Users
  static const String getDrivers = '/admin/get_drivers.php';
  static const String getPassengers = '/admin/get_passengers.php';
  static const String updateUserStatus = '/admin/update_user_status.php';
  static const String getUserDetails = '/admin/get_user_details.php';

  // Settings
  static const String getAllSettings = '/settings/get_all_settings.php';
  static const String updateSetting = '/settings/update_setting.php';

  // Driver Verification
  static const String submitVerification = '/verification/submit_verification.php';
  static const String getVerificationStatus = '/verification/get_verification_status.php';
  static const String reviewVerification = '/verification/review_verification.php';
  static const String listVerifications = '/verification/list_verifications.php';
  static const String verificationCounts = '/verification/verification_counts.php';

  // Vehicles
  static const String getVehicles = '/vehicles/get_vehicles.php';

  static const String addVehicle = '/vehicles/add_vehicle.php';
  static const String updateVehicle = '/vehicles/update_vehicle.php';
  static const String deleteVehicle = '/vehicles/delete_vehicle.php';

  static const String setDefaultVehicle = '/vehicles/set_default_vehicle.php';
  static const String getDefaultVehicle = '/vehicles/get_default_vehicle.php';

  static const String vehicleCount = '/vehicles/get_vehicle_count.php';

  //Settings
  static const String getSetting = '/settings/get_setting.php';

  // Rides
  static const String searchRides = '/rides/search.php';
  static const String rideDetails = '/rides/ride_details.php';
  static const String myRides = '/rides/my_rides.php';
  static const String postRide = '/rides/post_ride.php';
  static const String ridePassengers = '/rides/ride_passengers.php';
  static const String updateRideStatus = '/rides/update_ride_status.php';
  static const String completedRides = '/rides/completed_rides.php';

  static const String pendingRequestsCount = '/rides/pending_requests_count.php';
  static const String activeRidesCount = '/rides/active_rides_count.php';
  static const String completedRidesCount = '/rides/completed_rides_count.php';

  // Bookings
  static const String bookRide = '/bookings/book.php';
  static const String myBookings = '/bookings/my_bookings.php';
  static const String rideRequests = '/bookings/ride_requests.php';
  static const String updateBookingStatus = '/bookings/update_booking_status.php';
  static const String markRemainingNoShows = '/bookings/mark_remaining_no_shows.php';

  static const String passengerBookingsCount = '/bookings/passenger_bookings_count.php';
  static const String activeBookingsCount = '/bookings/active_bookings_count.php';
  static const String completedBookingsCount = '/bookings/completed_bookings_count.php';

  // Wallet
  static const String getWallet = '/wallet/get_wallet.php';
  static const String getWalletTransactions = '/wallet/get_wallet_transactions.php';
  static const String paymentSettings = '/wallet/payment_settings.php';
  static const String submitDepositRequest = '/wallet/submit_deposit_request.php';
  static const String submitWithdrawRequest = '/wallet/submit_withdraw_request.php';
  static const String myDepositRequests = '/wallet/my_deposit_requests.php';
  static const String myWithdrawRequests = '/wallet/my_withdraw_requests.php';


  // Profile
  static const String getProfile = '/profile/get_profile.php';

  // Ratings & reviews
  static const String submitRating = '/ratings/submit_rating.php';
  static const String getUserRatings = '/ratings/get_user_ratings.php';
  static const String canRate = '/ratings/can_rate.php';

  // Notifications
  static const String getNotifications = '/notifications/get_notifications.php';
  static const String markNotificationRead = '/notifications/mark_notification_read.php';
  static const String unreadNotificationCount = '/notifications/unread_notification_count.php';
}
