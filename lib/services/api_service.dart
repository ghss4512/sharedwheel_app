import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';
class ApiService {
  Future<dynamic> post({required String endpoint, required Map<String, dynamic> data,}) async {
    final response = await http.post(
      Uri.parse(AppConfig.baseUrl + endpoint,),
      body: data
    );
    return jsonDecode(response.body);
  }

  Future<dynamic> get({required String endpoint,}) async {
    final response = await http.get(
      Uri.parse(AppConfig.baseUrl + endpoint,),
    );

    return jsonDecode(response.body);
  }
}