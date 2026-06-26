import '../utils/api_endpoints.dart';
import 'api_service.dart';

class AuthService {
  final ApiService api = ApiService();

  Future<dynamic> login({
    required String loginInput,
    required String password,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.login,
      data: {'login_input': loginInput, 'pass': password},
    );
  }

  Future<Map<String, dynamic>> forgotPassword({required String mobile}) async {
    return await api.post(
      endpoint: ApiEndpoints.forgotPassword,
      data: {'mobile': mobile},
    );
  }

  Future<Map<String, dynamic>> verifyResetOtp({
    required String mobile,
    required String otp,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.verifyResetOtp,
      data: {'mobile': mobile, 'otp': otp},
    );
  }

  Future<Map<String, dynamic>> resetPassword({
    required String mobile,
    required String otp,
    required String newPassword,
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.resetPassword,
      data: {'mobile': mobile, 'otp': otp, 'new_password': newPassword},
    );
  }
}
