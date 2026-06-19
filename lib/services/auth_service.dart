import '../utils/api_endpoints.dart';
import 'api_service.dart';

class AuthService {
  final ApiService api = ApiService();
  Future<dynamic> login({required String loginInput, required String password,}) async {
    return await api.post(
      endpoint: ApiEndpoints.login,
      data: {
        'login_input': loginInput,
        'pass': password,
      },
    );
  }
}