import 'dart:convert';

import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  final int id;
  final OrderOwner orderOwner;
  final dynamic driver;
  final VehicleTypeModel typeVehicle;
  final AddressModel orderLocation;
  final String description;
  final AddressModel startPoint;
  final AddressModel endPoint;
  final String weight;
  final String price;
  final DateTime dateTime;
  final bool withCover;
  final String otherInfo;
  final String status;
  final DateTime createdAt;
  final List<PaymentMethodModel> paymentMethods;

  OrderModel({
    required this.id,
    required this.orderOwner,
    required this.driver,
    required this.typeVehicle,
    required this.orderLocation,
    required this.description,
    required this.startPoint,
    required this.endPoint,
    required this.weight,
    required this.price,
    required this.dateTime,
    required this.withCover,
    required this.otherInfo,
    required this.status,
    required this.createdAt,
    required this.paymentMethods,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        orderOwner: OrderOwner.fromJson(json["order_owner"]),
        driver: json["driver"],
        typeVehicle: VehicleTypeModel.fromJson(json["type_vehicle"]),
        orderLocation: AddressModel.fromJson(json["order_location"]),
        description: json["discription"],
        startPoint: AddressModel.fromJson(json["start_point"]),
        endPoint: AddressModel.fromJson(json["end_point"]),
        weight: json["weight"],
        price: json["price"],
        dateTime: DateTime.parse(json["DateTime"]),
        withCover: json["with_cover"],
        otherInfo: json["other_info"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        paymentMethods:
            List<PaymentMethodModel>.from(json["payment_methods"].map((x) => PaymentMethodModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_owner": orderOwner.toJson(),
        "driver": driver,
        "type_vehicle": typeVehicle.toJson(),
        "order_location": orderLocation.toJson(),
        "discription": description,
        "start_point": startPoint.toJson(),
        "end_point": endPoint.toJson(),
        "weight": weight,
        "price": price,
        "DateTime": dateTime.toIso8601String(),
        "with_cover": withCover,
        "other_info": otherInfo,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "payment_methods": List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
      };
}

class OrderOwner {
  final String name;
  final String phoneNumber;

  OrderOwner({
    required this.name,
    required this.phoneNumber,
  });

  factory OrderOwner.fromJson(Map<String, dynamic> json) => OrderOwner(
        name: json["name"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
      };
}
