import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class ExerciseService {
  final ApiService _apiService;

  const ExerciseService({ApiService? apiService})
      : _apiService = apiService ?? const ApiService();

  Future<List<dynamic>> getExercises({
    required int userId,
    required String date,
  }) async {
    final response = await _apiService.get(
      '${ApiConstants.exercises}?userId=$userId&date=$date',
    );

    return response['data'] as List<dynamic>;
  }

  Future<List<dynamic>> searchExerciseCatalog(String query) async {
    final response = await _apiService.get(
      '${ApiConstants.exerciseCatalogSearch}?q=$query',
    );

    return response['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createExercise({
    required int userId,
    required String name,
    required String category,
    required int durationMinutes,
    required int burnedCalories,
    required String performedAt,
  }) async {
    final response = await _apiService.post(
      ApiConstants.exercises,
      body: {
        'userId': userId,
        'name': name,
        'category': category,
        'durationMinutes': durationMinutes,
        'burnedCalories': burnedCalories,
        'performedAt': performedAt,
      },
    );

    return response['data'] as Map<String, dynamic>;
  }

  Future<void> deleteExercise(int id) async {
    await _apiService.delete('${ApiConstants.exercises}/$id');
  }
}
