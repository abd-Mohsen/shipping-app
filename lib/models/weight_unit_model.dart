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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeightUnitModel && other.runtimeType == runtimeType && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
