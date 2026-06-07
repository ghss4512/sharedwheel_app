import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';

class ApiService {
  Future<dynamic> get({required String endpoint, Map<String, dynamic>? queryParameters,}) async {
    Uri uri = Uri.parse(AppConfig.baseUrl + endpoint,);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(
        queryParameters: queryParameters.map(
              (key, value) =>
              MapEntry(key, value.toString()),
        ),
      );
    }

    final response = await http.get(uri);
    return jsonDecode(response.body);
  }

  Future<dynamic> post({required String endpoint, required Map<String, dynamic> data,}) async {
    final response = await http.post(
      Uri.parse(
        AppConfig.baseUrl + endpoint,
      ),
      body: data,
    );

    return jsonDecode(response.body);
  }
}