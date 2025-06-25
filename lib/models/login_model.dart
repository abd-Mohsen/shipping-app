import 'dart:convert';

import 'package:shipment/models/user_model.dart';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

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

class LoginModel {
  final int id;
  final String token;
  final Role role;

  LoginModel({
    required this.token,
    required this.id,
    required this.role,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        id: json["id"],
        token: json["token"],
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
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
