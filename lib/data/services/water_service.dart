import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class WaterService {
  final ApiService _apiService;

  const WaterService({ApiService? apiService})
      : _apiService = apiService ?? const ApiService();

  Future<Map<String, dynamic>> getWater({
    required int userId,
    required String date,
  }) async {
    final response = await _apiService.get(
      '${ApiConstants.water}?userId=$userId&date=$date',
    );

    return response['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateWater({
    required int userId,
    required String date,
    required int consumedMilliliter,
    required int targetMilliliter,
  }) async {
    final response = await _apiService.put(
      ApiConstants.water,
      body: {
        'userId': userId,
        'date': date,
        'consumedMilliliter': consumedMilliliter,
        'targetMilliliter': targetMilliliter,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }
}
