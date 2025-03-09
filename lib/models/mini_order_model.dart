import 'dart:convert';

List<MiniOrderModel> miniOrderModelFromJson(String str) =>
    List<MiniOrderModel>.from(json.decode(str)["orders"].map((x) => MiniOrderModel.fromJson(x)));

String miniOrderModelToJson(List<MiniOrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MiniOrderModel {
  final int orderId;
  final String driverName;
  final DateTime orderDateTime;
  final String orderVehicle;
  final String orderStatus;
  final String orderLocation;

  MiniOrderModel({
    required this.orderId,
    required this.driverName,
    required this.orderDateTime,
    required this.orderVehicle,
    required this.orderStatus,
    required this.orderLocation,
  });

  factory MiniOrderModel.fromJson(Map<String, dynamic> json) => MiniOrderModel(
        orderId: json["order_id"],
        driverName: json["driver_name"],
        orderDateTime: DateTime.parse(json["order_date_time"]),
        orderVehicle: json["order_vehicle"],
        orderStatus: json["order_status"],
        orderLocation: json["order_location"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "driver_name": driverName,
        "order_date_time": orderDateTime.toIso8601String(),
        "order_vehicle": orderVehicle,
        "order_status": orderStatus,
        "order_location": orderLocation,
      };
}
