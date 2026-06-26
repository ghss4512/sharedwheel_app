import 'dart:io';

import '../models/profile_model.dart';
import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';
import 'api_service.dart';

class ProfileService {
  final ApiService api = ApiService();

  Future<ProfileModel?> getProfile() async {
    final result = await api.get(
      endpoint: ApiEndpoints.getProfile,
      queryParameters: {'user_id': AppSession.userId.toString()},
    );

    if (result['success'] != true) {
      return null;
    }

    return ProfileModel.fromJson(result['profile']);
  }

  Future<dynamic> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String city,
    required String address,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.updateProfile,
      data: {
        'user_id': AppSession.userId.toString(),
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'city': city,
        'address': address,
      },
    );
  }

  Future<dynamic> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.changePassword,
      data: {
        'user_id': AppSession.userId.toString(),
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  Future<dynamic> uploadProfilePhoto(File imageFile) async {
    return await api.uploadFile(
      endpoint: ApiEndpoints.uploadProfilePhoto,
      file: imageFile,
      fieldName: 'photo',
      data: {'user_id': AppSession.userId.toString()},
    );
  }
}
