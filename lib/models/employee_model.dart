import 'dart:convert';

import 'package:shipment/models/mini_vehicle_model.dart';
import 'package:shipment/models/user_model.dart';
import 'package:shipment/models/vehicle_model.dart';

List<EmployeeModel> employeeModelFromJson(String str) =>
    List<EmployeeModel>.from(json.decode(str).map((x) => EmployeeModel.fromJson(x)));

String employeeModelToJson(List<EmployeeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeModel {
  final int id;
  final bool isAvailable;
  bool canAcceptOrders;
  final UserModel user;
  final DriverInfo? driver;
  final Role roleInCompany;
  MiniVehicleModel? vehicle;
  final DateTime joinDate;

  EmployeeModel({
    required this.id,
    required this.isAvailable,
    required this.canAcceptOrders,
    required this.user,
    required this.driver,
    required this.roleInCompany,
    required this.vehicle,
    required this.joinDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json["id"],
        isAvailable: json["is_available"],
        canAcceptOrders: json["can_accept_orders"],
        user: UserModel.fromJson(json["user"]),
        driver: DriverInfo.fromJson(json["driver"]),
        roleInCompany: Role.fromJson(json["role"]),
        vehicle: json["vehicle"] == null ? null : MiniVehicleModel.fromJson(json["vehicle"]),
        joinDate: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_available": isAvailable,
        "can_accept_orders": canAcceptOrders,
        "user": user.toJson(),
        "driver": driver!.toJson(),
        "role": roleInCompany.toJson(),
      };

  Employee toMini() {
    return Employee(id: id, fullName: user.toString(), username: "random username", canAcceptOrders: canAcceptOrders);
  }
}
