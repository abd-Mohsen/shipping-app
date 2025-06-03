import 'dart:convert';

import 'package:shipment/models/vehicle_type_model.dart';

List<ApplicationModel> applicationModelFromJson(String str) =>
    List<ApplicationModel>.from(json.decode(str).map((x) => ApplicationModel.fromJson(x)));

String applicationModelToJson(List<ApplicationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApplicationModel {
  final int id;
  final User driver;
  final User? acceptedBy;
  final Vehicle vehicle;
  final DateTime appliedAt; //todo: 10 min
  final DateTime? deletedAt;

  ApplicationModel({
    required this.id,
    required this.driver,
    required this.acceptedBy,
    required this.vehicle,
    required this.appliedAt,
    required this.deletedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => ApplicationModel(
        id: json["id"],
        driver: User.fromJson(json["driver"]),
        acceptedBy: User.fromJson(json["accepted_by"]),
        vehicle: Vehicle.fromJson(json["vehicle"]),
        appliedAt: DateTime.parse(json["applied_at"]),
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver": driver.toJson(),
        "accepted_by": acceptedBy?.toJson(),
        "vehicle": vehicle.toJson(),
        "applied_at": appliedAt.toIso8601String(),
      };
}

class User {
  final int id;
  final String name;
  final String phoneNumber;
  final double? overallRating;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.overallRating,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        overallRating: json["overall_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "overall_rating": overallRating,
      };
}

class Vehicle {
  final int id;
  final VehicleTypeModel vehicleType;

  Vehicle({
    required this.id,
    required this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        vehicleType: VehicleTypeModel.fromJson(json["vehicle_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_type": vehicleType.toJson(),
      };
}
