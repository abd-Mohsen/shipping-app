import 'dart:convert';

import 'package:shipment/models/user_model.dart';

List<EmployeeModel> employeeModelFromJson(String str) =>
    List<EmployeeModel>.from(json.decode(str).map((x) => EmployeeModel.fromJson(x)));

String employeeModelToJson(List<EmployeeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeModel {
  final int id;
  final bool isAvailable;
  final UserModel user;

  EmployeeModel({
    required this.id,
    required this.isAvailable,
    required this.user,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json["id"],
        isAvailable: json["is_available"],
        user: UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_available": isAvailable,
        "user": user.toJson(),
      };
}
