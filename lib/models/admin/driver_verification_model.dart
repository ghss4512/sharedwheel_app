class DriverVerificationModel {
  final int id;

  final String cnicFront;
  final String cnicBack;

  final String drivingLicense;
  final String vehicleRegistration;

  final String status;
  final String remarks;

  DriverVerificationModel({
    required this.id,
    required this.cnicFront,
    required this.cnicBack,
    required this.drivingLicense,
    required this.vehicleRegistration,
    required this.status,
    required this.remarks,
  });

  factory DriverVerificationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DriverVerificationModel(
      id: int.parse(json['id'].toString()),
      cnicFront: json['cnic_front'] ?? '',
      cnicBack: json['cnic_back'] ?? '',
      drivingLicense:
      json['driving_license'] ?? '',
      vehicleRegistration:
      json['vehicle_registration'] ?? '',
      status: json['status'] ?? 'pending',
      remarks: json['remarks'] ?? '',
    );
  }
}