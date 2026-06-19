class VehicleModel {
  final int id;
  final int driverId;

  final String vehicleType;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleColor;

  final int seatingCapacity;

  final bool isDefault;

  VehicleModel({
    required this.id,
    required this.driverId,
    required this.vehicleType,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleColor,
    required this.seatingCapacity,
    required this.isDefault,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: int.parse(json['id'].toString()),
      driverId: int.parse(json['driver_id'].toString()),

      vehicleType: json['vehicle_type'] ?? '',
      vehicleName: json['vehicle_name'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleColor: json['vehicle_color'] ?? '',

      seatingCapacity: int.tryParse(json['seating_capacity'].toString()) ?? 4,

      isDefault: json['is_default'].toString() == '1',
    );
  }
}
