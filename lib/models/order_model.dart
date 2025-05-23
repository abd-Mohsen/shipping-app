import 'dart:convert';

import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str)["results"].map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  final int id;
  final OrderOwner orderOwner;
  final OrderOwner? driver;
  final VehicleTypeModel typeVehicle;
  final OrderLocation orderLocation;
  final String description;
  final AddressModel startPoint;
  final AddressModel endPoint;
  final String weight;
  final double price;
  final DateTime dateTime;
  final String? otherInfo;
  final String status;
  final List<PaymentMethod> paymentMethods;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool ownerApproved;
  final bool driverApproved;
  final List<String> extraInfo;
  final Coordinates startCoordinates;
  final Coordinates endCoordinates;

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
    required this.otherInfo,
    required this.status,
    required this.paymentMethods,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerApproved,
    required this.driverApproved,
    required this.extraInfo,
    required this.startCoordinates,
    required this.endCoordinates,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        orderOwner: OrderOwner.fromJson(json["order_owner"]),
        driver: OrderOwner.fromJson(json["driver"]),
        typeVehicle: VehicleTypeModel.fromJson(json["type_vehicle"]),
        orderLocation: OrderLocation.fromJson(json["order_location"]),
        description: json["discription"],
        startPoint: AddressModel.fromJson(json["start_point"]),
        endPoint: AddressModel.fromJson(json["end_point"]),
        weight: json["weight"],
        price: json["price"],
        dateTime: DateTime.parse(json["DateTime"]),
        otherInfo: json["other_info"],
        status: json["status"],
        paymentMethods: List<PaymentMethod>.from(json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        ownerApproved: json["owner_is_approved"],
        driverApproved: json["driver_is_approved"],
        extraInfo: List<String>.from(json["order_extra_info"].map((x) => x)),
        startCoordinates: Coordinates.fromJson(json["start_coordinates"]),
        endCoordinates: Coordinates.fromJson(json["end_coordinates"]),
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
        "other_info": otherInfo,
        "status": status,
        "payment_methods": List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };

  String formatExtraInfo() {
    String res = "";
    for (String info in extraInfo) {
      res += "$info\n";
    }
    return res;
  }
}

class OrderLocation {
  final int id;
  final String name;

  OrderLocation({
    required this.id,
    required this.name,
  });

  factory OrderLocation.fromJson(Map<String, dynamic> json) => OrderLocation(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class OrderOwner {
  final String name;
  final String? phoneNumber;

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

class PaymentMethod {
  final int? id;
  final Payment payment;
  final bool isActive;

  PaymentMethod({
    required this.id,
    required this.payment,
    required this.isActive,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"] ?? json["order_payment_id"],
        payment: Payment.fromJson(json["payment"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment": payment.toJson(),
        "is_active": isActive,
      };
}

class Payment {
  final String methodName;
  final String? fullName;
  final String? phoneNumber;
  final String? accountDetails;
  final String? info;

  Payment({
    required this.methodName,
    required this.fullName,
    required this.phoneNumber,
    required this.accountDetails,
    required this.info,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        methodName: json["method_name"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        accountDetails: json["account_details"],
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "method_name": methodName,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "account_details": accountDetails,
        "info": info,
      };
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"]?.toDouble() ?? 0.0,
        longitude: json["longitude"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
