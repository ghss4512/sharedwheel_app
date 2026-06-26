class ComplaintLogModel {
  final int id;
  final int complaintId;
  final String note;
  final String createdAt;

  ComplaintLogModel({
    required this.id,
    required this.complaintId,
    required this.note,
    required this.createdAt,
  });

  factory ComplaintLogModel.fromJson(Map<String, dynamic> json) {
    return ComplaintLogModel(
      id: int.parse(json['id'].toString()),
      complaintId: int.parse(json['complaint_id'].toString()),
      note: json['note'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
