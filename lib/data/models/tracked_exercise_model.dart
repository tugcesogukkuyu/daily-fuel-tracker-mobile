class TrackedExerciseModel {
  final String id;
  final String name;
  final String category;
  final DateTime date;
  final int durationMinutes;
  final int burnedCalories;

  const TrackedExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.durationMinutes,
    required this.burnedCalories,
  });

  factory TrackedExerciseModel.create({
    required String name,
    required String category,
    required DateTime date,
    required int durationMinutes,
    required int burnedCalories,
  }) {
    return TrackedExerciseModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      category: category,
      date: date,
      durationMinutes: durationMinutes,
      burnedCalories: burnedCalories,
    );
  }
}
