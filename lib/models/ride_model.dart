class RideModel {
  final int id;

  final int driverId;
  final String? driverName;
  final String? driverPhone;
  final int createdBy;
  final int? updatedBy;
  final int? cancelledBy;

  final int vehicleId;

  final int fromCityId;
  final String fromCity;

  final int toCityId;
  final String toCity;

  final int fareId;
  final double farePerSeat;

  final String pickupLocation;
  final String dropLocation;

  final String travelDate;
  final String travelTime;

  final int totalSeats;
  final int availableSeats;

  final String vehicleName;
  final String vehicleNumber;
  final String vehicleColor;

  final String rideStatus;

  final DateTime? cancelledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? waitingStartedAt;
  final double rating;
  final int totalRatings;
  final int totalRides;
  final int totalBookings;
  final int bookedSeats;

  RideModel({
    required this.id,
    required this.driverId,
    this.driverName,
    this.driverPhone,
    required this.createdBy,
    this.updatedBy,
    this.cancelledBy,
    required this.vehicleId,
    required this.fromCityId,
    required this.fromCity,
    required this.toCityId,
    required this.toCity,
    required this.fareId,
    required this.farePerSeat,
    required this.pickupLocation,
    required this.dropLocation,
    required this.travelDate,
    required this.travelTime,
    required this.totalSeats,
    required this.availableSeats,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleColor,
    required this.rideStatus,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
    this.startedAt,
    this.completedAt,
    this.waitingStartedAt,
    this.rating = 0.0,
    this.totalRatings = 0,
    this.totalRides = 0,
    this.totalBookings = 0,
    this.bookedSeats = 0,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      driverId: int.tryParse(json['driver_id'].toString()) ?? 0,
      driverName: json['driver_name'] ?? '',
      driverPhone: json['driver_phone'] ?? '',
      createdBy: int.tryParse(json['created_by'].toString()) ?? 0,
      updatedBy: json['updated_by'] == null
          ? null
          : int.tryParse(json['updated_by'].toString()),
      cancelledBy: json['cancelled_by'] == null
          ? null
          : int.tryParse(json['cancelled_by'].toString()),
      vehicleId: int.tryParse(json['vehicle_id'].toString()) ?? 0,
      fromCityId: int.tryParse(json['from_city_id'].toString()) ?? 0,
      fromCity: json['from_city'] ?? '',
      toCityId: int.tryParse(json['to_city_id'].toString()) ?? 0,
      toCity: json['to_city'] ?? '',
      fareId: int.tryParse(json['fare_id'].toString()) ?? 0,
      farePerSeat: double.tryParse(json['fare_per_seat'].toString()) ?? 0,
      pickupLocation: json['pickup_location'] ?? '',
      dropLocation: json['drop_location'] ?? '',
      travelDate: json['travel_date'] ?? '',
      travelTime: json['travel_time'] ?? '',
      totalSeats: int.tryParse(json['total_seats'].toString()) ?? 0,
      availableSeats: int.tryParse(json['available_seats'].toString()) ?? 0,
      vehicleName: json['vehicle_name'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleColor: json['vehicle_color'] ?? '',
      rideStatus: json['ride_status'] ?? '',
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.tryParse(json['cancelled_at'].toString()),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
      startedAt: json['started_at'] == null
          ? null
          : DateTime.tryParse(json['started_at'].toString()),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.tryParse(json['completed_at'].toString()),

      waitingStartedAt: json['waiting_started_at'] == null
          ? null
          : DateTime.tryParse(json['waiting_started_at'].toString()),

      rating: double.tryParse(json['rating'].toString()) ?? 0,
      totalRatings: int.tryParse(json['total_rating'].toString()) ?? 0,
      totalRides: int.tryParse(json['total_rides'].toString()) ?? 0,
      totalBookings: int.tryParse(json['total_bookings'].toString()) ?? 0,
      bookedSeats: int.tryParse(json['booked_seats'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'cancelled_by': cancelledBy,
      'vehicle_id': vehicleId,
      'from_city_id': fromCityId,
      'from_city': fromCity,
      'to_city_id': toCityId,
      'to_city': toCity,
      'fare_id': fareId,
      'fare_per_seat': farePerSeat,
      'pickup_location': pickupLocation,
      'drop_location': dropLocation,
      'travel_date': travelDate,
      'travel_time': travelTime,
      'total_seats': totalSeats,
      'available_seats': availableSeats,
      'vehicle_name': vehicleName,
      'vehicle_number': vehicleNumber,
      'vehicle_color': vehicleColor,
      'ride_status': rideStatus,
      'cancelled_at': cancelledAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'waiting_started_at': waitingStartedAt?.toIso8601String(),
      'rating': rating,
      'total_rating': totalRatings,
      'total_rides': totalRides,
      'total_bookings': totalBookings,
      'booked_seats' : bookedSeats,
    };
  }

  String get route => '$fromCity → $toCity';

  String get vehicle => '$vehicleName ($vehicleNumber)';

  String get fareText => 'Rs. ${farePerSeat.toStringAsFixed(0)} / Seat';

  bool get isScheduled => rideStatus == 'scheduled';

  bool get isEnroute => rideStatus == 'enroute';

  bool get isArrived => rideStatus == 'arrived';

  bool get isWaiting => rideStatus == 'waiting';

  bool get isInProgress => rideStatus == 'in_progress';

  bool get isCompleted => rideStatus == 'completed';

  bool get isCancelled => rideStatus == 'cancelled';

  bool get hasAvailableSeats => availableSeats > 0;
}
