import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Role role;
  final bool isVerified;
  final String? idPhotoFront;
  final String idStatus;
  final String? idPhotoRare;
  final DriverInfo? driverInfo;
  final CompanyInfo? companyInfo;
  final Wallet? wallet;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    required this.isVerified,
    required this.driverInfo,
    required this.companyInfo,
    required this.idPhotoFront,
    required this.idPhotoRare,
    required this.idStatus,
    required this.wallet,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        idPhotoFront: json["ID_photo_front"],
        idPhotoRare: json["ID_photo_rare"],
        idStatus: json["ID_status"] ?? "",
        role: Role.fromJson(json["role"]),
        wallet: json["wallet"] != null ? Wallet.fromJson(json["wallet"]) : null,
        isVerified: json["is_verified"],
        driverInfo: json["driver_info"] == null ? null : DriverInfo.fromJson(json["driver_info"]),
        companyInfo: json["company_info"] == null ? null : CompanyInfo.fromJson(json["company_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "role": role.toJson(),
        "is_verified": isVerified,
        "driver_info": driverInfo!.toJson(),
        "company_info": companyInfo!.toJson(),
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

class CompanyInfo {
  final String name;
  final int membersNum;
  final int vehicleNum;
  //final List<UserModel> employees;

  CompanyInfo({
    required this.name,
    required this.membersNum,
    required this.vehicleNum,
    //required this.employees,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
        name: json["name"],
        membersNum: json["members_num"],
        vehicleNum: json["vehicle_num"],
        //employees: List<UserModel>.from(json["employees"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "members_num": membersNum,
        "vehicle_num": vehicleNum,
        //"employees": List<dynamic>.from(employees.map((x) => x.toJson())),
      };
}

class Wallet {
  final String balance;
  final String reservedCommission;

  Wallet({
    required this.balance,
    required this.reservedCommission,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        balance: json["balance"] ?? "", //todo: needs modification
        reservedCommission: json["reserved_commission"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "reserved_commission": reservedCommission,
      };
}
