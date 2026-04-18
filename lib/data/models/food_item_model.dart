class FoodItemModel {
  final int id;
  final String name;
  final String category;
  final String servingLabel;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  const FoodItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.servingLabel,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  
factory FoodItemModel.fromJson(Map<String, dynamic> json) {
  double parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  int parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  return FoodItemModel(
    id: parseInt(json['id']),
    name: json['name'] as String,
    category: json['category'] as String,
    servingLabel: (json['serving_label'] ?? json['servingLabel']) as String,
    calories: parseInt(json['calories']),
    protein: parseDouble(json['protein']),
    carbs: parseDouble(json['carbs']),
    fat: parseDouble(json['fat']),
  );
}


}
