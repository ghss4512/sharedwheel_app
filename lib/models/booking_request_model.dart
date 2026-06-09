class BookingRequestModel {
  final int bookingId;
  final int rideId;
  final int passengerId;

  final String passengerName;
  final String passengerPhone;

  final String fromCity;
  final String toCity;

  final String travelDate;
  final String travelTime;

  final int seatsBooked;
  final double totalFare;

  final String bookingStatus;

  BookingRequestModel({
    required this.bookingId,
    required this.rideId,
    required this.passengerId,
    required this.passengerName,
    required this.passengerPhone,
    required this.fromCity,
    required this.toCity,
    required this.travelDate,
    required this.travelTime,
    required this.seatsBooked,
    required this.totalFare,
    required this.bookingStatus,
  });

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      bookingId: int.parse(json['id'].toString()),
      rideId: int.parse(json['ride_id'].toString()),
      passengerId: int.parse(json['passenger_id'].toString()),
      passengerName: json['full_name'] ?? '',
      passengerPhone: json['phone'] ?? '',
      fromCity: json['from_city'] ?? '',
      toCity: json['to_city'] ?? '',
      travelDate: json['travel_date'] ?? '',
      travelTime: json['travel_time'] ?? '',
      seatsBooked: int.parse(json['seats_booked'].toString()),
      totalFare: double.parse(json['total_fare'].toString()),
      bookingStatus: json['booking_status'] ?? '',
    );
  }
}