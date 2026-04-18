class ExerciseModel {
  final int id;
  final String name;
  final String category;
  final DateTime date;
  final int durationMinutes;
  final int burnedCalorie;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.durationMinutes,
    required this.burnedCalorie,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      durationMinutes: json['durationMinutes'],
      burnedCalorie: json['burnedCalorie'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'burnedCalorie': burnedCalorie,
    };
  }
}
