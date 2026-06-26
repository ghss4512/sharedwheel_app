class DashboardStatsModel {
  final int drivers;
  final int passengers;
  final int pendingDeposits;
  final int pendingWithdrawals;
  final int pendingVerifications;
  final int activeRides;
  final int pendingBookings;
  final int completedRides;
  final int activeUsers;
  final int cancelledRides;
  final int pendingComplaints;
  final int scheduledRides;
  final int suspendedUsers;
  final int totalBookings;
  final int totalComplaints;
  final int totalDeposits;
  final int totalWithdrawals;
  final int unverifiedDrivers;
  final int verifiedDrivers;
  final int totalRideFares;
  final int totalCities;

  DashboardStatsModel({
    required this.drivers,
    required this.passengers,
    required this.pendingDeposits,
    required this.pendingWithdrawals,
    required this.pendingVerifications,
    required this.activeRides,
    required this.pendingBookings,
    required this.completedRides,
    required this.activeUsers,
    required this.cancelledRides,
    required this.pendingComplaints,
    required this.scheduledRides,
    required this.suspendedUsers,
    required this.totalBookings,
    required this.totalComplaints,
    required this.totalDeposits,
    required this.totalWithdrawals,
    required this.unverifiedDrivers,
    required this.verifiedDrivers,
    required this.totalRideFares,
    required this.totalCities,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      drivers: int.tryParse(json['drivers'].toString()) ?? 0,
      passengers: int.tryParse(json['passengers'].toString()) ?? 0,
      pendingDeposits: int.tryParse(json['pending_deposits'].toString()) ?? 0,
      pendingWithdrawals: int.tryParse(json['pending_withdrawals'].toString()) ?? 0,
      pendingVerifications: int.tryParse(json['pending_verifications'].toString()) ?? 0,
      activeRides: int.tryParse(json['active_rides'].toString()) ?? 0,
      pendingBookings: int.tryParse(json['pending_bookings'].toString()) ?? 0,
      completedRides: int.tryParse(json['completed_rides'].toString()) ?? 0,
      activeUsers: int.tryParse(json['active_users'].toString()) ?? 0,
      cancelledRides: int.tryParse(json['cancelled_rides'].toString()) ?? 0,
      pendingComplaints: int.tryParse(json['pending_complaints'].toString()) ?? 0,
      scheduledRides: int.tryParse(json['scheduled_rides'].toString()) ?? 0,
      suspendedUsers: int.tryParse(json['suspended_users'].toString()) ?? 0,
      totalBookings: int.tryParse(json['total_bookings'].toString()) ?? 0,
      totalComplaints: int.tryParse(json['total_complaints'].toString()) ?? 0,
      totalDeposits: int.tryParse(json['total_deposits'].toString()) ?? 0,
      totalWithdrawals: int.tryParse(json['total_withdrawals'].toString()) ?? 0,
      unverifiedDrivers: int.tryParse(json['unverified_drivers'].toString()) ?? 0,
      verifiedDrivers: int.tryParse(json['verified_drivers'].toString()) ?? 0,
      totalRideFares: int.tryParse(json['total_ride_fares'].toString()) ?? 0,
      totalCities: int.tryParse(json['total_cities'].toString()) ?? 0,
    );
  }
}
