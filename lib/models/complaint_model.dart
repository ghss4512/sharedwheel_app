class ComplaintModel {
  final int id;
  final int rideId;
  final int complainantId;
  final int againstUserId;
  final String category;
  final String complaintType;
  final String subject;
  final String complaintText;
  final String status;
  final String adminRemarks;

  final String againstUserName;
  final String againstUserPhoto;

  final String complainantName;
  final String complainantPhoto;

  final String createdAt;
  final String? resolvedAt;

  ComplaintModel({
    required this.id,
    required this.rideId,
    required this.complainantId,
    required this.againstUserId,
    required this.category,
    required this.complaintType,
    required this.subject,
    required this.complaintText,
    required this.status,
    required this.adminRemarks,
    required this.againstUserName,
    required this.againstUserPhoto,
    required this.complainantName,
    required this.complainantPhoto,
    required this.createdAt,
    this.resolvedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: int.parse(json['id'].toString()),
      rideId: int.tryParse(json['ride_id'].toString()) ?? 0,
      complainantId: int.parse(json['complainant_id'].toString()),
      againstUserId: int.parse(json['against_user_id'].toString()),
      category: json['category'] ?? 'other',
      complaintType: json['complaint_type'] ?? '',
      subject: json['subject'] ?? '',
      complaintText: json['complaint_text'] ?? '',
      status: json['status'] ?? 'pending',
      adminRemarks: json['admin_remarks'] ?? '',
      againstUserName: json['against_user_name'] ?? '',
      againstUserPhoto: json['against_user_photo'] ?? '',
      complainantName: json['complainant_name'] ?? '',
      complainantPhoto: json['complainant_photo'] ?? '',
      createdAt: json['created_at'] ?? '',
      resolvedAt: json['resolved_at'],
    );
  }
}
