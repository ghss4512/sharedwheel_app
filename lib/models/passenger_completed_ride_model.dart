class PassengerCompletedRideModel {
  // Ride
  final int rideId;
  final String fromCity;
  final String toCity;
  final String travelDate;
  final String travelTime;
  final double farePerSeat;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleColor;
  final String rideStatus;

  // Booking
  final int bookingId;
  final int seatsBooked;
  final String bookingStatus;
  final String bookingDate;
  final double totalFare;

  // Driver
  final int driverId;
  final String driverName;
  final String driverPhone;
  final String driverPhoto;

  // Rating
  final double driverRating;
  final int totalReviews;
  final bool alreadyRated;
  final double myRating;
  final String myReview;

  PassengerCompletedRideModel({
    required this.rideId,
    required this.fromCity,
    required this.toCity,
    required this.travelDate,
    required this.travelTime,
    required this.farePerSeat,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleColor,
    required this.rideStatus,
    required this.bookingId,
    required this.seatsBooked,
    required this.bookingStatus,
    required this.bookingDate,
    required this.totalFare,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.driverPhoto,
    required this.driverRating,
    required this.totalReviews,
    required this.alreadyRated,
    required this.myRating,
    required this.myReview
  });

  factory PassengerCompletedRideModel.fromJson(Map<String, dynamic> json) {
    return PassengerCompletedRideModel(
      // Ride
      rideId: int.tryParse(json['id'].toString()) ?? 0,
      fromCity: json['from_city'] ?? '',
      toCity: json['to_city'] ?? '',
      travelDate: json['travel_date'] ?? '',
      travelTime: json['travel_time'] ?? '',
      farePerSeat: double.tryParse(json['fare_per_seat'].toString()) ?? 0,
      vehicleName: json['vehicle_name'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleColor: json['vehicle_color'] ?? '',
      rideStatus: json['ride_status'] ?? '',

      // Booking
      bookingId: int.tryParse(json['booking_id'].toString()) ?? 0,
      seatsBooked: int.tryParse(json['seats_booked'].toString()) ?? 0,
      bookingStatus: json['booking_status'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      totalFare: double.tryParse(json['total_fare'].toString()) ?? 0,

      // Driver
      driverId: int.tryParse(json['driver_id'].toString()) ?? 0,
      driverName: json['driver_name'] ?? '',
      driverPhone: json['phone'] ?? '',
      driverPhoto: json['profile_photo'] ?? '',

      // Rating
      driverRating: double.tryParse(json['driver_rating'].toString()) ?? 0,
      totalReviews: int.tryParse(json['total_reviews'].toString()) ?? 0,
      alreadyRated: json['already_rated'].toString() == '1',
      myRating: double.tryParse(json['my_rating'].toString()) ?? 0,
      myReview: json['my_review'].toString(),
    );
  }
}
