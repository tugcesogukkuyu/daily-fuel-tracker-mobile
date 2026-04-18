class MealModel {
  final int id;
  final String name;
  final String mealType;
  final DateTime date;
  final int calorie;
  final double protein;
  final double carbohydrate;
  final double fat;

  const MealModel({
    required this.id,
    required this.name,
    required this.mealType,
    required this.date,
    required this.calorie,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      name: json['name'],
      mealType: json['mealType'],
      date: DateTime.parse(json['date']),
      calorie: json['calorie'],
      protein: (json['protein'] as num).toDouble(),
      carbohydrate: (json['carbohydrate'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mealType': mealType,
      'date': date.toIso8601String(),
      'calorie': calorie,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'fat': fat,
    };
  }
}
