import 'dart:convert';

import 'package:shipment/models/vehicle_type_model.dart';

List<VehicleModel> vehicleModelFromJson(String str) =>
    List<VehicleModel>.from(json.decode(str).map((x) => VehicleModel.fromJson(x)));

String vehicleModelToJson(List<VehicleModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleModel {
  final int id;
  final int owner;
  final String fullNameOwner;
  final int vehicleType;
  final VehicleTypeModel vehicleTypeInfo;
  final String licensePlate;
  final String vehicleRegistrationPhoto;
  final DateTime createdAt;
  final dynamic updatedAt;

  VehicleModel({
    required this.id,
    required this.owner,
    required this.fullNameOwner,
    required this.vehicleType,
    required this.vehicleTypeInfo,
    required this.licensePlate,
    required this.vehicleRegistrationPhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        owner: json["owner"],
        fullNameOwner: json["full_name_owner"],
        vehicleType: json["vehicle_type"],
        vehicleTypeInfo: VehicleTypeModel.fromJson(json["vehicle_type_info"]),
        licensePlate: json["vehicle_registration_number"],
        vehicleRegistrationPhoto: json["vehicle_registration_photo"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "full_name_owner": fullNameOwner,
        "vehicle_type": vehicleType,
        "vehicle_type_info": vehicleTypeInfo.toJson(),
        "vehicle_registration_number": licensePlate,
        "vehicle_registration_photo": vehicleRegistrationPhoto,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
