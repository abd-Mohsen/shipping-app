import 'dart:convert';

import 'package:shipment/models/user_model.dart';

List<EmployeeModel> employeeModelFromJson(String str) =>
    List<EmployeeModel>.from(json.decode(str).map((x) => EmployeeModel.fromJson(x)));

String employeeModelToJson(List<EmployeeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeModel {
  final int id;
  final bool isAvailable;
  final UserModel user;
  final DriverInfo? driver;
  final Role roleInCompany;
  final DateTime joinDate;

  EmployeeModel({
    required this.id,
    required this.isAvailable,
    required this.user,
    required this.driver,
    required this.roleInCompany,
    required this.joinDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json["id"],
        isAvailable: json["is_available"],
        user: UserModel.fromJson(json["user"]),
        driver: json["driver"] == null ? null : DriverInfo.fromJson(json["driver"]),
        roleInCompany: Role.fromJson(json["role"]),
        joinDate: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_available": isAvailable,
        "user": user.toJson(),
        "role": roleInCompany.toJson(),
      };
}

class Role {
  final String type;
  final String name;

  Role({
    required this.type,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        type: json["type"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
      };
}

class DriverInfo {
  final int? id;
  final String? drivingLicensePhotoFront;
  final String? drivingLicensePhotoRare;
  final String licenseStatus;
  final String vehicleStatus;
  final bool inCompany;

  DriverInfo({
    this.id,
    required this.drivingLicensePhotoFront,
    required this.drivingLicensePhotoRare,
    required this.licenseStatus,
    required this.vehicleStatus,
    required this.inCompany,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) => DriverInfo(
        id: json["id"],
        drivingLicensePhotoFront: json["driving_license_photo_front"],
        drivingLicensePhotoRare: json["driving_license_photo_rare"],
        licenseStatus: json["license_status"],
        vehicleStatus: json["vehicle_status"],
        inCompany: json["in_company"],
      );

  Map<String, dynamic> toJson() => {
        "driving_license_photo_front": drivingLicensePhotoFront,
        "driving_license_photo_rare": drivingLicensePhotoRare,
        "license_status": licenseStatus,
        "vehicle_status": vehicleStatus,
        "in_company": inCompany,
      };
}
