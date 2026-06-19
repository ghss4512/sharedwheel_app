class BookingModel {
  final int id;
  final int rideId;
  final int passengerId;
  final int driverId;
  final int seatsBooked;
  final double farePerSeat;
  final double totalFare;
  final String bookingStatus;
  final String rideStatus;
  final String paymentStatus;
  final String fromCity;
  final String toCity;
  final String travelDate;
  final String travelTime;
  final String driverName;
  final bool canRate;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.rideId,
    required this.passengerId,
    required this.driverId,
    required this.seatsBooked,
    required this.farePerSeat,
    required this.totalFare,
    required this.bookingStatus,
    required this.rideStatus,
    required this.paymentStatus,
    required this.fromCity,
    required this.toCity,
    required this.travelDate,
    required this.travelTime,
    required this.driverName,
    required this.canRate,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: int.parse(json['id'].toString()),
      rideId: int.parse(json['ride_id'].toString()),
      passengerId: int.parse(json['passenger_id'].toString()),
      driverId: int.parse(json['driver_id'].toString()),
      seatsBooked: int.parse(json['seats_booked'].toString()),
      farePerSeat: double.parse(json['fare_per_seat'].toString()),
      totalFare: double.parse(json['total_fare'].toString()),
      bookingStatus: json['booking_status'] ?? '',
      rideStatus: json['ride_status'] ?? 'scheduled',
      paymentStatus: json['payment_status'] ?? '',
      fromCity: json['from_city'] ?? '',
      toCity: json['to_city'] ?? '',
      travelDate: json['travel_date'] ?? '',
      travelTime: json['travel_time'] ?? '',
      driverName: json['driver_name'] ?? '',
      canRate: json['can_rate'] == true || json['can_rate'].toString() == '1',
      createdAt: json['created_at'] ?? '',
    );
  }
}
