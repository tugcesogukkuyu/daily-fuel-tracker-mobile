import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class MealService {
  final ApiService _apiService;

  const MealService({ApiService? apiService})
      : _apiService = apiService ?? const ApiService();

  Future<List<dynamic>> getMeals({
    required int userId,
    required String date,
  }) async {
    final response = await _apiService.get(
      '${ApiConstants.meals}?userId=$userId&date=$date',
    );

    return response['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createMeal({
    required int userId,
    required int foodId,
    required String mealType,
    required String consumedAt,
  }) async {
    final response = await _apiService.post(
      ApiConstants.meals,
      body: {
        'userId': userId,
        'foodId': foodId,
        'mealType': mealType,
        'consumedAt': consumedAt,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  Future<void> deleteMeal(int id) async {
    await _apiService.delete('${ApiConstants.meals}/$id');
  }
}
