import '../../core/constants/api_constants.dart';
import '../models/food_item_model.dart';
import 'api_service.dart';

class FoodDataService {
  final ApiService _apiService;

  const FoodDataService({ApiService? apiService})
      : _apiService = apiService ?? const ApiService();

  Future<List<FoodItemModel>> loadFoods() async {
    final response = await _apiService.get(ApiConstants.foods);
    final foodsJson = response['data'] as List<dynamic>;

    return foodsJson
        .map(
          (item) => FoodItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  List<String> getCategories(List<FoodItemModel> foods) {
    final categories = foods.map((food) => food.category).toSet().toList()
      ..sort();

    return ['Tümü', ...categories];
  }
}
