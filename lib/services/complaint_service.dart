import '../models/complaint_model.dart';
import '../models/complaint_log_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';

class ComplaintService {
  final ApiService api = ApiService();

  Future<Map<String, dynamic>> createComplaint({
    required int rideId,
    required int complainantId,
    required int againstUserId,
    required String category,
    required String complaintType,
    required String subject,
    required String complaintText,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.createComplaint,
      data: {
        'ride_id': rideId.toString(),
        'complainant_id': complainantId.toString(),
        'against_user_id': againstUserId.toString(),
        'category': category,
        'complaint_type': complaintType,
        'subject': subject,
        'complaint_text': complaintText,
      },
    );
  }

  Future<List<ComplaintModel>> getMyComplaints(int userId) async {
    final result = await api.get(
      endpoint: ApiEndpoints.myComplaints,
      queryParameters: {'user_id': userId.toString()},
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['complaints'] as List)
        .map((e) => ComplaintModel.fromJson(e))
        .toList();
  }

  Future<Map<String, dynamic>?> getComplaintDetails(int complaintId) async {
    final result = await api.get(
      endpoint: ApiEndpoints.complaintDetails,
      queryParameters: {'complaint_id': complaintId.toString()},
    );

    if (result['success'] != true) {
      return null;
    }

    final complaint = ComplaintModel.fromJson(result['complaint']);

    final logs = (result['logs'] as List)
        .map((e) => ComplaintLogModel.fromJson(e))
        .toList();

    return {'complaint': complaint, 'logs': logs};
  }

}
