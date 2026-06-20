import '../models/admin/dashboard_stats_model.dart';
import '../models/admin/pending_deposit_model.dart';
import '../models/admin/pending_withdrawal_model.dart';
import '../models/admin/settings_model.dart';
import '../models/ride_model.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';

class AdminService {
  final ApiService api = ApiService();

  Future<List<PendingDepositModel>> getPendingDeposits() async {
    final result = await api.get(endpoint: ApiEndpoints.getPendingDeposits);

    if (result['success'] != true) {
      return [];
    }

    return (result['deposits'] as List)
        .map((e) => PendingDepositModel.fromJson(e))
        .toList();
  }

  Future<dynamic> approveDeposit(int transactionId) async {
    return await api.post(
      endpoint: ApiEndpoints.approveDeposit,
      data: {'transaction_id': transactionId.toString()},
    );
  }

  Future<dynamic> rejectDeposit(int transactionId) async {
    return await api.post(
      endpoint: ApiEndpoints.rejectDeposit,
      data: {'transaction_id': transactionId.toString()},
    );
  }

  Future<List<PendingWithdrawalModel>> getPendingWithdrawals() async {
    final result = await api.get(endpoint: ApiEndpoints.getPendingWithdrawals);

    if (result['success'] != true) {
      return [];
    }

    return (result['withdrawals'] as List)
        .map((e) => PendingWithdrawalModel.fromJson(e))
        .toList();
  }

  Future<dynamic> approveWithdrawal(int withdrawalId) async {
    return await api.post(
      endpoint: ApiEndpoints.approveWithdrawal,
      data: {'withdrawal_id': withdrawalId.toString()},
    );
  }

  Future<dynamic> rejectWithdrawal(int withdrawalId) async {
    return await api.post(
      endpoint: ApiEndpoints.rejectWithdrawal,
      data: {'withdrawal_id': withdrawalId.toString()},
    );
  }

  Future<DashboardStatsModel> getDashboardStats() async {
    final result = await api.get(endpoint: ApiEndpoints.dashboardStats);

    if (result['success'] == true) {
      return DashboardStatsModel.fromJson(result);
    }

    return DashboardStatsModel(
      drivers: 0,
      passengers: 0,
      pendingDeposits: 0,
      pendingWithdrawals: 0,
      pendingVerifications: 0,
      activeRides: 0,
      pendingBookings: 0,
    );
  }

  Future<List<PendingDepositModel>> getDepositHistory() async {
    final result = await api.get(endpoint: ApiEndpoints.depositHistory);
    if (result['success'] != true) {
      return [];
    }

    return (result['deposits'] as List)
        .map((e) => PendingDepositModel.fromJson(e))
        .toList();
  }

  Future<List<PendingWithdrawalModel>> getWithdrawalHistory() async {
    final result = await api.get(endpoint: ApiEndpoints.withdrawalHistory);
    if (result['success'] != true) {
      return [];
    }
    return (result['withdrawals'] as List)
        .map((e) => PendingWithdrawalModel.fromJson(e))
        .toList();
  }

  Future<SettingsModel> getAllSettings() async {
    final result = await api.get(endpoint: ApiEndpoints.getAllSettings);
    if (result['success'] == true) {
      return SettingsModel.fromJson(result['settings']);
    }
    return SettingsModel(settings: {});
  }

  Future<dynamic> updateSetting({
    required String key,
    required String value,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.updateSetting,
      data: {'key': key, 'value': value},
    );
  }

  Future<List<UserModel>> getDrivers() async {
    final result = await api.get(endpoint: ApiEndpoints.getDrivers);
    if (result['success'] != true) {
      return [];
    }
    return (result['drivers'] as List)
        .map((driver) => UserModel.fromJson(driver))
        .toList();
  }

  Future<List<UserModel>> getPassengers() async {
    final result = await api.get(endpoint: ApiEndpoints.getPassengers);
    if (result['success'] != true) {
      return [];
    }
    return (result['passengers'] as List)
        .map((passenger) => UserModel.fromJson(passenger))
        .toList();
  }

  Future<dynamic> updateUserStatus({
    required int userId,
    required String status,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.updateUserStatus,
      data: {'user_id': userId.toString(), 'status': status},
    );
  }

  Future<UserModel?> getUserDetails(int userId) async {
    final result = await api.get(
      endpoint: ApiEndpoints.getUserDetails,
      queryParameters: {'user_id': userId.toString()},
    );
    if (result['success'] != true) {
      return null;
    }
    return UserModel.fromJson(result['user']);
  }

  Future<List<RideModel>> getScheduledRides() async {
    final result = await api.get(endpoint: ApiEndpoints.getScheduledRides);
    if (result['success'] != true) {
      return [];
    }
    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }

  Future<List<RideModel>> getActiveRides() async {
    final result = await api.get(endpoint: ApiEndpoints.getActiveRides);
    if (result['success'] != true) {
      return [];
    }
    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }

  Future<List<RideModel>> getCancelledRides() async {
    final result = await api.get(endpoint: ApiEndpoints.getCancelledRides);
    if (result['success'] != true) {
      return [];
    }
    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }

  Future<List<RideModel>> getCompletedRides() async {
    final result = await api.get(endpoint: ApiEndpoints.getCompletedRides);
    if (result['success'] != true) {
      return [];
    }
    return (result['rides'] as List)
        .map((ride) => RideModel.fromJson(ride))
        .toList();
  }

  Future<dynamic> getRideDetails(int rideId) async {
    return await api.get(
      endpoint: ApiEndpoints.getRideDetails,
      queryParameters: {'ride_id': rideId.toString()},
    );
  }

  Future<dynamic> cancelRide(int rideId) async {
    return await api.post(
      endpoint: ApiEndpoints.cancelRide,
      data: {'ride_id': rideId.toString()},
    );
  }

  Future<dynamic> completeRide(int rideId) async {
    return await api.post(
      endpoint: ApiEndpoints.completeRide,
      data: {'ride_id': rideId.toString()},
    );
  }

  // Bookings
  Future<List<BookingModel>> getPendingBookings() async {
    final result = await api.get(endpoint: ApiEndpoints.getPendingBookings);
    if (result['success'] != true) {
      return [];
    }
    return (result['bookings'] as List)
        .map((booking) => BookingModel.fromJson(booking))
        .toList();
  }

  Future<List<BookingModel>> getApprovedBookings() async {
    final result = await api.get(endpoint: ApiEndpoints.getApprovedBookings);
    if (result['success'] != true) {
      return [];
    }
    return (result['bookings'] as List)
        .map((booking) => BookingModel.fromJson(booking))
        .toList();
  }

  Future<List<BookingModel>> getCompletedBookings() async {
    final result = await api.get(endpoint: ApiEndpoints.getCompletedBookings);
    if (result['success'] != true) {
      return [];
    }

    return (result['bookings'] as List)
        .map((booking) => BookingModel.fromJson(booking))
        .toList();
  }

  Future<List<BookingModel>> getCancelledBookings() async {
    final result = await api.get(endpoint: ApiEndpoints.getCancelledBookings);
    if (result['success'] != true) {
      return [];
    }

    return (result['bookings'] as List)
        .map((booking) => BookingModel.fromJson(booking))
        .toList();
  }

  Future<List<BookingModel>> getNoShowBookings() async {
    final result = await api.get(endpoint: ApiEndpoints.getNoShowBookings);
    if (result['success'] != true) {
      return [];
    }

    return (result['bookings'] as List)
        .map((booking) => BookingModel.fromJson(booking))
        .toList();
  }

  Future<dynamic> getBookingDetails(int bookingId) async {
    return await api.get(
      endpoint: ApiEndpoints.getBookingDetails,
      queryParameters: {'booking_id': bookingId.toString()},
    );
  }

  Future<dynamic> approveBooking(int bookingId) async {
    return await api.post(
      endpoint: ApiEndpoints.approveBooking,
      data: {'booking_id': bookingId.toString()},
    );
  }

  Future<dynamic> cancelBooking(int bookingId) async {
    return await api.post(
      endpoint: ApiEndpoints.cancelBooking,
      data: {'booking_id': bookingId.toString()},
    );
  }

  Future<dynamic> rejectBooking(int bookingId) async {
    return await api.post(
      endpoint: ApiEndpoints.rejectBooking,
      data: {'booking_id': bookingId.toString()},
    );
  }

  Future<dynamic> markNoShow(int bookingId) async {
    return await api.post(
      endpoint: ApiEndpoints.markNoShow,
      data: {'booking_id': bookingId.toString()},
    );
  }

  Future<dynamic> markBoarded(int bookingId) async {
    return await api.post(
      endpoint: ApiEndpoints.markBoarded,
      data: {'booking_id': bookingId.toString()},
    );
  }

  Future<dynamic> completeBooking(int bookingId) async {
    return await api.post(
      endpoint: ApiEndpoints.completeBooking,
      data: {'booking_id': bookingId.toString()},
    );
  }
}
