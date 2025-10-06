import 'dart:convert';

import 'package:shipment/models/mini_vehicle_model.dart';
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
  final String registrationPhoto;
  final String registrationStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;
  Employee? employee;

  VehicleModel({
    required this.id,
    required this.owner,
    required this.fullNameOwner,
    required this.vehicleType,
    required this.vehicleTypeInfo,
    required this.licensePlate,
    required this.registrationPhoto,
    required this.registrationStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        owner: json["owner"],
        fullNameOwner: json["full_name_owner"],
        vehicleType: json["vehicle_type"],
        vehicleTypeInfo: VehicleTypeModel.fromJson(json["vehicle_type_info"]),
        licensePlate: json["vehicle_registration_number"].toString(),
        registrationPhoto: json["vehicle_registration_photo"],
        registrationStatus: json["registration_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: null,
        employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "full_name_owner": fullNameOwner,
        "vehicle_type": vehicleType,
        "vehicle_type_info": vehicleTypeInfo.toJson(),
        "vehicle_registration_number": licensePlate,
        "vehicle_registration_photo": registrationPhoto,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };

  @override
  String toString() {
    return "$fullNameOwner #$licensePlate";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleModel && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  MiniVehicleModel toMiniModel() {
    return MiniVehicleModel(id: id, vehicleRegistrationNumber: licensePlate, vehicleType: vehicleTypeInfo.type);
  }
}

class Employee {
  final int id;
  final String fullName;
  final String username;
  final bool canAcceptOrders;

  Employee({
    required this.id,
    required this.fullName,
    required this.username,
    required this.canAcceptOrders,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        fullName: json["full_name"],
        username: json["username"],
        canAcceptOrders: json["can_accept_orders"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "username": username,
        "can_accept_orders": canAcceptOrders,
      };
}
