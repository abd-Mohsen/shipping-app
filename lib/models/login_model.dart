import 'dart:convert';

List<LoginModel> loginModelFromJson(String str) =>
    List<LoginModel>.from(json.decode(str).map((x) => LoginModel.fromJson(x)));

String loginModelToJson(List<LoginModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginModel {
  final String token;
  final User user;
  final Driver driver;
  final dynamic company;

  LoginModel({
    required this.token,
    required this.user,
    required this.driver,
    required this.company,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"],
        user: User.fromJson(json["user"]),
        driver: Driver.fromJson(json["driver"]),
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
        "driver": driver.toJson(),
        "company": company,
      };
}

class Driver {
  final String drivingLicensePhotoFront;
  final String drivingLicensePhotoRare;
  final String idPhotoFront;
  final String idPhotoRare;
  final bool isVerifiedLicense;
  final bool isVerifiedId;
  final bool hasAVechicle;
  final bool inCompany;

  Driver({
    required this.drivingLicensePhotoFront,
    required this.drivingLicensePhotoRare,
    required this.idPhotoFront,
    required this.idPhotoRare,
    required this.isVerifiedLicense,
    required this.isVerifiedId,
    required this.hasAVechicle,
    required this.inCompany,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
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

class User {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Role role;

  User({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "role": role.toJson(),
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
