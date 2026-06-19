class DriverVerification {
  final int id;
  final int driverId;
  final String fullName;
  final String phone;
  final String status;

  final String cnicFront;
  final String cnicBack;
  final String drivingLicense;
  final String vehicleRegistration;

  final String remarks;

  DriverVerification({
    required this.id,
    required this.driverId,
    required this.fullName,
    required this.phone,
    required this.status,
    required this.cnicFront,
    required this.cnicBack,
    required this.drivingLicense,
    required this.vehicleRegistration,
    required this.remarks,
  });

  factory DriverVerification.fromJson(Map<String, dynamic> json) {
    return DriverVerification(
      id: int.parse(json['id'].toString()),
      driverId: int.parse(json['driver_id'].toString()),
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      cnicFront: json['cnic_front'] ?? '',
      cnicBack: json['cnic_back'] ?? '',
      drivingLicense: json['driving_license'] ?? '',
      vehicleRegistration: json['vehicle_registration'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}
