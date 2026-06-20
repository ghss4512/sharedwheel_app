class DashboardStatsModel {
  final int drivers;
  final int passengers;

  final int pendingDeposits;
  final int pendingWithdrawals;

  final int pendingVerifications;
  final int activeRides;

  final int pendingBookings;

  DashboardStatsModel({
    required this.drivers,
    required this.passengers,
    required this.pendingDeposits,
    required this.pendingWithdrawals,
    required this.pendingVerifications,
    required this.activeRides,
    required this.pendingBookings,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      drivers: int.tryParse(json['drivers'].toString()) ?? 0,
      passengers: int.tryParse(json['passengers'].toString()) ?? 0,
      pendingDeposits: int.tryParse(json['pending_deposits'].toString()) ?? 0,
      pendingWithdrawals: int.tryParse(json['pending_withdrawals'].toString()) ?? 0,
      pendingVerifications: int.tryParse(json['pending_verifications'].toString()) ?? 0,
      activeRides: int.tryParse(json['active_rides'].toString()) ?? 0,
      pendingBookings: int.tryParse(json['pending_bookings'].toString(),) ?? 0,
    );
  }
}
