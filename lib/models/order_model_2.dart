import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/currency_model.dart';

List<OrderModel2> orderModel2FromJson(String str) =>
    List<OrderModel2>.from(json.decode(str)["results"].map((x) => OrderModel2.fromJson(x)));

class OrderModel2 {
  final int id;
  final OrderOwner? orderOwner;
  final String description;
  final AddressModel startPoint;
  final AddressModel endPoint;
  final double price;
  final CurrencyModel currency;
  final DateTime dateTime;
  final String status;
  final DateTime createdAt;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final bool isCancelledByMe;

  OrderModel2({
    required this.id,
    required this.orderOwner,
    required this.description,
    required this.startPoint,
    required this.endPoint,
    required this.price,
    required this.currency,
    required this.dateTime,
    required this.status,
    required this.createdAt,
    required this.startedAt,
    required this.finishedAt,
    required this.isCancelledByMe,
  });

  factory OrderModel2.fromJson(Map<String, dynamic> json) => OrderModel2(
        id: json["id"],
        orderOwner: OrderOwner.fromJson(json["order_owner"]),
        description: json["discription"],
        startPoint: AddressModel.fromJson(json["start_point"]),
        endPoint: AddressModel.fromJson(json["end_point"]),
        price: json["price"],
        currency: CurrencyModel.fromJson(json["currency"]),
        dateTime: DateTime.parse(json["DateTime"]),
        status: (json["is_canceled_by_me"] ?? false) ? "canceled" : json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        startedAt: json["started_at"] == null ? DateTime.now() : DateTime.parse(json["started_at"]),
        finishedAt: json["finished_at"] == null ? null : DateTime.parse(json["finished_at"]),
        isCancelledByMe: json["is_canceled_by_me"] ?? false,
      );

  String shortAddress() {
    return "${startPoint.governorate} - ${endPoint.governorate}";
  }

  String fullDate() {
    return "${Jiffy.parseFromDateTime(dateTime).format(pattern: "d/M/y")}  ${Jiffy.parseFromDateTime(dateTime).jm}";
  }

  String shortDate() {
    return Jiffy.parseFromDateTime(dateTime).format(pattern: "d / M / y");
  }
}

class OrderOwner {
  final String name;
  final String phoneNumber;

  OrderOwner({
    required this.name,
    required this.phoneNumber,
  });

  factory OrderOwner.fromJson(Map<String, dynamic> json) => OrderOwner(
        name: json["name"] ?? "name",
        phoneNumber: json["phone_number"] ?? "phone_number",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
      };
}
