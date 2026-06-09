class RideModel {
  final int id;
  final int driverId;

  final String fromCity;
  final String toCity;

  final String pickupLocation;
  final String dropLocation;

  final String travelDate;
  final String travelTime;

  final int totalSeats;
  final int availableSeats;

  final double farePerSeat;

  final String vehicleName;
  final String vehicleNumber;
  final String vehicleColor;

  final String driverName;
  final String profilePhoto;
  final double rating;
  final int totalRides;

  final String rideStatus;

  final String? waitingStartedAt;

  RideModel({
    required this.id,
    required this.driverId,
    required this.fromCity,
    required this.toCity,
    required this.pickupLocation,
    required this.dropLocation,
    required this.travelDate,
    required this.travelTime,
    required this.totalSeats,
    required this.availableSeats,
    required this.farePerSeat,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleColor,

    required this.driverName,
    required this.profilePhoto,
    required this.rating,
    required this.totalRides,

    required this.rideStatus,
    required this.waitingStartedAt,

  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: int.parse(json['id'].toString()),
      driverId: int.parse(json['driver_id'].toString()),
      fromCity: json['from_city'] ?? '',
      toCity: json['to_city'] ?? '',
      pickupLocation: json['pickup_location'] ?? '',
      dropLocation: json['drop_location'] ?? '',
      travelDate: json['travel_date'] ?? '',
      travelTime: json['travel_time'] ?? '',
      totalSeats: int.parse(json['total_seats'].toString()),
      availableSeats: int.parse(json['available_seats'].toString()),
      farePerSeat: double.parse(json['fare_per_seat'].toString()),
      vehicleName: json['vehicle_name'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleColor: json['vehicle_color'] ?? '',
      driverName: json['full_name'] ?? '',
      profilePhoto: json['profile_photo'] ?? '',
      rating: double.tryParse(json['rating'].toString(),) ?? 0,
      totalRides: int.tryParse(json['total_rides'].toString(),) ?? 0,
      rideStatus: json['ride_status'] ?? '',
      waitingStartedAt: json['waiting_started_at'],
    );
  }
}