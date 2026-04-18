import 'package:flutter/foundation.dart';

import '../models/food_item_model.dart';
import '../models/tracked_exercise_model.dart';
import '../models/tracked_meal_model.dart';
import '../services/exercise_service.dart';
import '../services/meal_service.dart';
import '../services/water_service.dart';
import 'auth_store.dart';

class DailyTrackerStore extends ChangeNotifier {
  DailyTrackerStore();

  final MealService _mealService = const MealService();
  final ExerciseService _exerciseService = const ExerciseService();
  final WaterService _waterService = const WaterService();

  DateTime selectedDate = DateTime.now();

  List<TrackedMealModel> _meals = [];
  List<TrackedExerciseModel> _exercises = [];

  int consumedWaterMilliliter = 0;
  int targetWaterMilliliter = 2000;

  bool isLoading = false;

  List<TrackedMealModel> get mealsForSelectedDate => _meals;
  List<TrackedExerciseModel> get exercisesForSelectedDate => _exercises;

  int get totalMealCalories {
    return _meals.fold(0, (total, meal) => total + meal.calories);
  }

  int get totalBurnedCalories {
    return _exercises.fold(
      0,
      (total, exercise) => total + exercise.burnedCalories,
    );
  }

  int get netCalories {
    return totalMealCalories - totalBurnedCalories;
  }

  double get totalProtein {
    return _meals.fold(0, (total, meal) => total + meal.protein);
  }

  double get totalCarbs {
    return _meals.fold(0, (total, meal) => total + meal.carbs);
  }

  double get totalFat {
    return _meals.fold(0, (total, meal) => total + meal.fat);
  }

  double get consumedWaterLiter {
    return consumedWaterMilliliter / 1000;
  }

  double get targetWaterLiter {
    return targetWaterMilliliter / 1000;
  }

  double get waterProgress {
    if (targetWaterMilliliter == 0) return 0;
    final value = consumedWaterMilliliter / targetWaterMilliliter;
    return value.clamp(0, 1);
  }

  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
    refreshForSelectedDate();
  }

  Future<void> refreshForSelectedDate() async {
    final userId = authStore.userId;
    if (userId == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final date = _formatDate(selectedDate);

      final mealsJson = await _mealService.getMeals(
        userId: userId,
        date: date,
      );

      final exercisesJson = await _exerciseService.getExercises(
        userId: userId,
        date: date,
      );

      final waterJson = await _waterService.getWater(
        userId: userId,
        date: date,
      );

      _meals = mealsJson.map((item) {
        return TrackedMealModel(
          id: item['id'].toString(),
          name: item['name'] as String,
          mealType: (item['meal_type'] ?? item['mealType']) as String,
          date: DateTime.parse(
            (item['consumed_at'] ?? item['consumedAt']) as String,
          ),
          calories: (item['calories'] as num).toInt(),
          protein: _parseDouble(item['protein']),
          carbs: _parseDouble(item['carbs']),
          fat: _parseDouble(item['fat']),
          servingLabel:
              (item['serving_label'] ?? item['servingLabel']) as String,
        );
      }).toList();

      _exercises = exercisesJson.map((item) {
        return TrackedExerciseModel(
          id: item['id'].toString(),
          name: item['name'] as String,
          category: item['category'] as String,
          date: DateTime.parse(
            (item['performed_at'] ?? item['performedAt']) as String,
          ),
          durationMinutes: (item['duration_minutes'] as num).toInt(),
          burnedCalories: (item['burned_calories'] as num).toInt(),
        );
      }).toList();

      consumedWaterMilliliter =
          (waterJson['consumed_milliliter'] as num).toInt();
      targetWaterMilliliter =
          (waterJson['target_milliliter'] as num).toInt();
    } catch (error) {
      debugPrint('DailyTrackerStore refresh error: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMealFromFood({
    required FoodItemModel food,
    required String mealType,
  }) async {
    final userId = authStore.userId;
    if (userId == null) return false;

    try {
      await _mealService.createMeal(
        userId: userId,
        foodId: food.id,
        mealType: mealType,
        consumedAt: _buildSelectedDateTimeIso(),
      );

      await refreshForSelectedDate();
      return true;
    } catch (error) {
      debugPrint('Add meal error: $error');
      return false;
    }
  }

  Future<void> deleteMeal(String mealId) async {
    try {
      await _mealService.deleteMeal(int.parse(mealId));
      await refreshForSelectedDate();
    } catch (error) {
      debugPrint('Delete meal error: $error');
    }
  }

  Future<bool> addExercise({
    required String name,
    required String category,
    required int durationMinutes,
    required int burnedCalories,
  }) async {
    final userId = authStore.userId;
    if (userId == null) return false;

    try {
      await _exerciseService.createExercise(
        userId: userId,
        name: name,
        category: category,
        durationMinutes: durationMinutes,
        burnedCalories: burnedCalories,
        performedAt: _buildSelectedDateTimeIso(),
      );

      await refreshForSelectedDate();
      return true;
    } catch (error) {
      debugPrint('Add exercise error: $error');
      return false;
    }
  }

  Future<void> deleteExercise(String exerciseId) async {
    try {
      await _exerciseService.deleteExercise(int.parse(exerciseId));
      await refreshForSelectedDate();
    } catch (error) {
      debugPrint('Delete exercise error: $error');
    }
  }

  Future<void> addWaterGlass() async {
    await _updateWater(consumedWaterMilliliter + 200);
  }

  Future<void> removeWaterGlass() async {
    final nextValue = consumedWaterMilliliter - 200;
    await _updateWater(nextValue < 0 ? 0 : nextValue);
  }

  Future<void> _updateWater(int nextConsumedMilliliter) async {
    final userId = authStore.userId;
    if (userId == null) return;

    try {
      final result = await _waterService.updateWater(
        userId: userId,
        date: _formatDate(selectedDate),
        consumedMilliliter: nextConsumedMilliliter,
        targetMilliliter: targetWaterMilliliter,
      );

      consumedWaterMilliliter =
          (result['consumed_milliliter'] as num).toInt();
      targetWaterMilliliter =
          (result['target_milliliter'] as num).toInt();

      notifyListeners();
    } catch (error) {
      debugPrint('Update water error: $error');
    }
  }

  double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _buildSelectedDateTimeIso() {
    final localDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      12,
      0,
      0,
    );
    return localDateTime.toIso8601String();
  }
}

final DailyTrackerStore dailyTrackerStore = DailyTrackerStore();
