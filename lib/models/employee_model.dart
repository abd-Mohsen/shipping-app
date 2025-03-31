import 'dart:convert';

import 'package:shipment/models/user_model.dart';

List<EmployeeModel> employeeModelFromJson(String str) =>
    List<EmployeeModel>.from(json.decode(str).map((x) => EmployeeModel.fromJson(x)));

String employeeModelToJson(List<EmployeeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeModel {
  final int id;
  final bool isAvailable;
  final UserModel user;
  final Role roleInCompany;

  EmployeeModel({
    required this.id,
    required this.isAvailable,
    required this.user,
    required this.roleInCompany,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json["id"],
        isAvailable: json["is_available"],
        user: UserModel.fromJson(json["user"]),
        roleInCompany: Role.fromJson(json["role"]),
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
