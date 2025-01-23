import 'dart:convert';

List<VehicleTypeModel> vehicleTypeModelFromJson(String str) =>
    List<VehicleTypeModel>.from(json.decode(str).map((x) => VehicleTypeModel.fromJson(x)));

String vehicleTypeModelToJson(List<VehicleTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleTypeModel {
  final int id;
  final String type;

  VehicleTypeModel({
    required this.id,
    required this.type,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
      };
}
