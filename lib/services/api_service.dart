import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/app_config.dart';

class ApiService {

  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri uri = Uri.parse(AppConfig.baseUrl + endpoint);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}',);
    }

    return jsonDecode(response.body);
  }


  Future<dynamic> post({required String endpoint, required Map<String, dynamic> data, }) async {
    final Map<String, String> body = data.map((key, value) => MapEntry(key, value?.toString() ?? ''),);
    final response = await http.post(
      Uri.parse(AppConfig.baseUrl + endpoint),
      body: body,
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> uploadFile({
    required String endpoint,
    required File file,
    required String fieldName,
    Map<String, String>? data,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(AppConfig.baseUrl + endpoint),
    );
    if (data != null) {
      request.fields.addAll(data);
    }
    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    return jsonDecode(responseBody);
  }
}
