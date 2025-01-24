import 'dart:convert';

List<VehicleModel> vehicleModelFromJson(String str) =>
    List<VehicleModel>.from(json.decode(str).map((x) => VehicleModel.fromJson(x)));

String vehicleModelToJson(List<VehicleModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleModel {
  final int id;
  final int owner;
  final String fullNameOwner;
  final int vehicleType;
  final String licensePlate;
  final String registrationPhotoPath;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  VehicleModel({
    required this.id,
    required this.owner,
    required this.fullNameOwner,
    required this.vehicleType,
    required this.licensePlate,
    required this.registrationPhotoPath,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        owner: json["owner"],
        fullNameOwner: json["full_name_owner"],
        vehicleType: json["vehicle_type"],
        licensePlate: json["vehicle_registration_number"],
        registrationPhotoPath: json["vehicle_registration_photo"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "full_name_owner": fullNameOwner,
        "vehicle_type": vehicleType,
        "vehicle_registration_number": licensePlate,
        "vehicle_registration_photo": registrationPhotoPath,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
