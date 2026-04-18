import 'food_item_model.dart';

class TrackedMealModel {
  final String id;
  final String name;
  final String mealType;
  final DateTime date;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String servingLabel;

  const TrackedMealModel({
    required this.id,
    required this.name,
    required this.mealType,
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingLabel,
  });

  factory TrackedMealModel.fromFood({
    required FoodItemModel food,
    required String mealType,
    required DateTime date,
  }) {
    return TrackedMealModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: food.name,
      mealType: mealType,
      date: date,
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fat: food.fat,
      servingLabel: food.servingLabel,
    );
  }
}
