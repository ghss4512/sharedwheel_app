class PassengerModel {
  final int bookingId;
  final int passengerId;

  final String fullName;
  final String phone;

  final int seatsBooked;
  final double totalFare;

  final String bookingStatus;

  PassengerModel({
    required this.bookingId,
    required this.passengerId,
    required this.fullName,
    required this.phone,
    required this.seatsBooked,
    required this.totalFare,
    required this.bookingStatus,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      bookingId: int.parse(json['id'].toString()),
      passengerId: int.parse(json['passenger_id'].toString()),
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      seatsBooked: int.parse(json['seats_booked'].toString()),
      totalFare: double.parse(json['total_fare'].toString()),
      bookingStatus: json['booking_status'] ?? 'approved',
    );
  }
}
