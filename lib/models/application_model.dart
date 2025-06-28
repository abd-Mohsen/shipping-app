import 'dart:convert';

import 'package:shipment/models/vehicle_type_model.dart';

List<ApplicationModel> applicationModelFromJson(String str) =>
    List<ApplicationModel>.from(json.decode(str).map((x) => ApplicationModel.fromJson(x)));

class ApplicationModel {
  final int id;
  final Driver driver;
  final User? acceptedBy;
  final Vehicle vehicle;
  final bool canSeePhone;
  final DateTime appliedAt; //todo: 10 min
  final DateTime? deletedAt;

  ApplicationModel({
    required this.id,
    required this.driver,
    required this.acceptedBy,
    required this.vehicle,
    required this.canSeePhone,
    required this.appliedAt,
    required this.deletedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => ApplicationModel(
        id: json["id"],
        driver: Driver.fromJson(json["driver"]),
        acceptedBy: User.fromJson(json["accepted_by"]),
        vehicle: Vehicle.fromJson(json["vehicle"]),
        canSeePhone: json["can_see_customer_phone"],
        appliedAt: DateTime.parse(json["applied_at"]),
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver": driver.toJson(),
        "accepted_by": acceptedBy?.toJson(),
        "vehicle": vehicle.toJson(),
        "can_see_customer_phone": canSeePhone,
        "applied_at": appliedAt.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
      };
}

class User {
  final int id;
  final String name;
  final String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
      };
}

class Driver {
  final int id;
  final String name;
  final String phoneNumber;
  final double overallRating;
  final String drivingLicensePhotoRare;
  final String drivingLicensePhotoFront;

  Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.overallRating,
    required this.drivingLicensePhotoRare,
    required this.drivingLicensePhotoFront,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        overallRating: json["overall_rating"],
        drivingLicensePhotoRare: json["driving_license_photo_rare"],
        drivingLicensePhotoFront: json["driving_license_photo_front"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "overall_rating": overallRating,
        "driving_license_photo_rare": drivingLicensePhotoRare,
        "driving_license_photo_front": drivingLicensePhotoFront,
      };
}

class Vehicle {
  final int id;
  final VehicleType vehicleType;
  final Owner owner;
  final String vehicleRegistrationNumber;
  final String vehicleRegistrationPhoto;

  Vehicle({
    required this.id,
    required this.vehicleType,
    required this.owner,
    required this.vehicleRegistrationNumber,
    required this.vehicleRegistrationPhoto,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        vehicleType: VehicleType.fromJson(json["vehicle_type"]),
        owner: Owner.fromJson(json["owner"]),
        vehicleRegistrationNumber: json["vehicle_registration_number"],
        vehicleRegistrationPhoto: json["vehicle_registration_photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_type": vehicleType.toJson(),
        "owner": owner.toJson(),
        "vehicle_registration_number": vehicleRegistrationNumber,
        "vehicle_registration_photo": vehicleRegistrationPhoto,
      };
}

class Owner {
  final String fullName;
  final String phoneNumber;

  Owner({
    required this.fullName,
    required this.phoneNumber,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "phone_number": phoneNumber,
      };
}

class VehicleType {
  final int id;
  final String type;
  final bool canAcceptMultipleOrdersSameProvince;

  VehicleType({
    required this.id,
    required this.type,
    required this.canAcceptMultipleOrdersSameProvince,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
        id: json["id"],
        type: json["type"],
        canAcceptMultipleOrdersSameProvince: json["can_accept_multiple_orders_same_province"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "can_accept_multiple_orders_same_province": canAcceptMultipleOrdersSameProvince,
      };
}
