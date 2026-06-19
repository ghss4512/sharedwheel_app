import '../models/profile_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';

class ProfileService {
  final ApiService api = ApiService();
  Future<ProfileModel?> getProfile() async {
    if (AppSession.userId == null) {
      return null;
    }
    final result = await api.get(
      endpoint: ApiEndpoints.getProfile,
      queryParameters: {'user_id': AppSession.userId.toString()},
    );
    if (result['success'] != true) {
      return null;
    }
    return ProfileModel.fromJson(result['profile']);
  }
}