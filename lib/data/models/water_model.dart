class WaterModel {
  final int id;
  final DateTime date;
  final int consumedMilliliter;
  final int targetMilliliter;

  const WaterModel({
    required this.id,
    required this.date,
    required this.consumedMilliliter,
    required this.targetMilliliter,
  });

  factory WaterModel.fromJson(Map<String, dynamic> json) {
    return WaterModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      consumedMilliliter: json['consumedMilliliter'],
      targetMilliliter: json['targetMilliliter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'consumedMilliliter': consumedMilliliter,
      'targetMilliliter': targetMilliliter,
    };
  }

  double get consumedLiter => consumedMilliliter / 1000;
  double get targetLiter => targetMilliliter / 1000;
}
