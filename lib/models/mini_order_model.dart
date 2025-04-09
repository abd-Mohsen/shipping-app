import 'dart:convert';

List<MiniOrderModel> miniOrderModelFromJson(String str) =>
    List<MiniOrderModel>.from(json.decode(str)["orders"].map((x) => MiniOrderModel.fromJson(x)));

String miniOrderModelToJson(List<MiniOrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MiniOrderModel {
  final int orderId;
  final String driverName;
  final DateTime dateTime;
  final String vehicle;
  final String description;
  final String status;
  final String location;
  final Point startPoint;
  final Point endPoint;

  MiniOrderModel({
    required this.orderId,
    required this.driverName,
    required this.dateTime,
    required this.vehicle,
    required this.description,
    required this.status,
    required this.location,
    required this.startPoint,
    required this.endPoint,
  });

  factory MiniOrderModel.fromJson(Map<String, dynamic> json) => MiniOrderModel(
        orderId: json["order_id"],
        driverName: json["driver_name"],
        dateTime: DateTime.parse(json["date_time"]),
        vehicle: json["vehicle"],
        description: json["discription"],
        status: json["status"],
        location: json["location"],
        startPoint: Point.fromJson(json["start_point"]),
        endPoint: Point.fromJson(json["end_point"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "driver_name": driverName,
        "date_time": dateTime.toIso8601String(),
        "vehicle": vehicle,
        "discription": description,
        "status": status,
        "location": location,
        "start_point": startPoint.toJson(),
        "end_point": endPoint.toJson(),
      };
}

class Point {
  final String name;
  final String fullPath;

  Point({
    required this.name,
    required this.fullPath,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        name: json["name"],
        fullPath: json["full_path"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "full_path": fullPath,
      };
}
