import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  const ApiService();

  Future<Map<String, dynamic>> get(String url) async {
    final response = await http.get(Uri.parse(url));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String url) async {
    final response = await http.delete(Uri.parse(url));
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    }

    throw Exception(decodedBody['message'] ?? 'Bir API hatası oluştu.');
  }
}
