import 'dart:convert';

List<GovernorateModel> governorateModelFromJson(String str) =>
    List<GovernorateModel>.from(json.decode(str).map((x) => GovernorateModel.fromJson(x)));

String governorateModelToJson(List<GovernorateModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GovernorateModel {
  final int id;
  final String name;

  GovernorateModel({
    required this.id,
    required this.name,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) => GovernorateModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
