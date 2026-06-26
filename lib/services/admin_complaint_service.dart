import '../models/complaint_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';

class AdminComplaintService {
  final ApiService api = ApiService();

  Future<List<ComplaintModel>> getComplaints({String? status}) async {
    final result = await api.get(
      endpoint: ApiEndpoints.getComplaints,
      queryParameters: status != null && status.isNotEmpty
          ? {'status': status}
          : null,
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['complaints'] as List)
        .map((e) => ComplaintModel.fromJson(e))
        .toList();
  }

  Future<Map<String, dynamic>> updateComplaintStatus({
    required int complaintId,
    required String status,
    required String remarks,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.updateComplaintStatus,
      data: {
        'complaint_id': complaintId.toString(),
        'status': status,
        'admin_remarks': remarks,
      },
    );
  }

  Future<Map<String, dynamic>> addComplaintLog({
    required int complaintId,
    required String note,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.addComplaintLog,
      data: {'complaint_id': complaintId.toString(), 'note': note},
    );
  }
}
