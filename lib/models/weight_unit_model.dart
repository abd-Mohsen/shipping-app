class WeightUnitModel {
  final String value;
  final String label;

  WeightUnitModel({
    required this.value,
    required this.label,
  });

  factory WeightUnitModel.fromJson(Map<String, dynamic> json) => WeightUnitModel(
        value: json["value"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
      };

  @override
  String toString() {
    return label;
  }
}
