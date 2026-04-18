import '../../core/constants/api_constants.dart';
import '../services/api_service.dart';

class AuthService {
  final ApiService _apiService;

  const AuthService({ApiService? apiService})
      : _apiService = apiService ?? const ApiService();

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiConstants.register,
      body: {
        'fullName': fullName,
        'email': email,
        'password': password,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiConstants.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }
}
