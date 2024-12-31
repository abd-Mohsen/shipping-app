import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompanyInfo {
  final String name;
  final int membersNum;
  final int vehicleNum;
  final List<UserModel> employees;

  CompanyInfo({
    required this.name,
    required this.membersNum,
    required this.vehicleNum,
    required this.employees,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
        name: json["name"],
        membersNum: json["members_num"],
        vehicleNum: json["vehicle_num"],
        employees: List<UserModel>.from(json["employees"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "members_num": membersNum,
        "vehicle_num": vehicleNum,
        "employees": List<dynamic>.from(employees.map((x) => x.toJson())),
      };
}

class UserModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Role role;
  final DriverInfo? driverInfo;
  final CompanyInfo? companyInfo;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    required this.driverInfo,
    required this.companyInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        role: Role.fromJson(json["role"]),
        driverInfo: json["driver_info"] == null ? null : DriverInfo.fromJson(json["driver_info"]),
        companyInfo: json["company_info"] == null ? null : CompanyInfo.fromJson(json["company_info"]),
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "role": role.toJson(),
        "driver_info": driverInfo!.toJson(),
        "company_info": companyInfo!.toJson(),
      };
}

class DriverInfo {
  final String drivingLicensePhotoFront;
  final String drivingLicensePhotoRare;
  final String idPhotoFront;
  final String idPhotoRare;
  final bool isVerifiedLicense;
  final bool isVerifiedId;
  final bool hasAVechicle;
  final bool inCompany;

  DriverInfo({
    required this.drivingLicensePhotoFront,
    required this.drivingLicensePhotoRare,
    required this.idPhotoFront,
    required this.idPhotoRare,
    required this.isVerifiedLicense,
    required this.isVerifiedId,
    required this.hasAVechicle,
    required this.inCompany,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) => DriverInfo(
        drivingLicensePhotoFront: json["driving_license_photo_front"],
        drivingLicensePhotoRare: json["driving_license_photo_rare"],
        idPhotoFront: json["ID_photo_front"],
        idPhotoRare: json["ID_photo_rare"],
        isVerifiedLicense: json["is_verified_license"],
        isVerifiedId: json["is_verified_ID"],
        hasAVechicle: json["has_a_vechicle"],
        inCompany: json["in_company"],
      );

  Map<String, dynamic> toJson() => {
        "driving_license_photo_front": drivingLicensePhotoFront,
        "driving_license_photo_rare": drivingLicensePhotoRare,
        "ID_photo_front": idPhotoFront,
        "ID_photo_rare": idPhotoRare,
        "is_verified_license": isVerifiedLicense,
        "is_verified_ID": isVerifiedId,
        "has_a_vechicle": hasAVechicle,
        "in_company": inCompany,
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
