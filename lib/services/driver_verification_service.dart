import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/admin/driver_verification.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';
import '../utils/app_config.dart';

class DriverVerificationService {
  final ApiService api = ApiService();

  static const String baseUrl = AppConfig.baseUrl;

  Future<Map<String, dynamic>> getStatus() async {
    return await api.get(
      endpoint: ApiEndpoints.getVerificationStatus,
      queryParameters: {'driver_id': AppSession.userId.toString()},
    );
  }

  Future<Map<String, dynamic>> submitVerification({
    required File cnicFront,
    required File cnicBack,
    required File drivingLicense,
    required File vehicleRegistration,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl${ApiEndpoints.submitVerification}'),
    );
    request.fields['driver_id'] = AppSession.userId.toString();
    request.files.add(
      await http.MultipartFile.fromPath('cnic_front', cnicFront.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath('cnic_back', cnicBack.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath('driving_license', drivingLicense.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'vehicle_registration',
        vehicleRegistration.path,
      ),
    );
    final response = await request.send();
    final body = await response.stream.bytesToString();
    return jsonDecode(body);
  }

  Future<List<DriverVerification>> getVerifications({String? status}) async {
    final result = await api.get(
      endpoint: ApiEndpoints.listVerifications,
      queryParameters: status == null || status.isEmpty
          ? {}
          : {'status': status},
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['verifications'] as List)
        .map((e) => DriverVerification.fromJson(e))
        .toList();
  }

  Future<Map<String, dynamic>> reviewVerification({
    required int verificationId,
    required String status,
    required String remarks,
  }) async {
    final result = await api.post(
      endpoint: ApiEndpoints.reviewVerification,
      data: {
        'verification_id': verificationId.toString(),
        'status': status,
        'remarks': remarks,
      },
    );

    return result;
  }

  Future<Map<String, dynamic>> getVerificationCounts() async {
    return await api.get(endpoint: ApiEndpoints.verificationCounts);
  }
}
