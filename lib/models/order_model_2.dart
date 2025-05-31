import 'dart:convert';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/currency_model.dart';

List<OrderModel2> orderModel2FromJson(String str) =>
    List<OrderModel2>.from(json.decode(str)["results"].map((x) => OrderModel2.fromJson(x)));

class OrderModel2 {
  final int id;
  final String description;
  final AddressModel startPoint;
  final AddressModel endPoint;
  final double price;
  final CurrencyModel currency;
  final DateTime dateTime;
  final String status;
  final DateTime createdAt;

  OrderModel2({
    required this.id,
    required this.description,
    required this.startPoint,
    required this.endPoint,
    required this.price,
    required this.currency,
    required this.dateTime,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel2.fromJson(Map<String, dynamic> json) => OrderModel2(
        id: json["id"],
        description: json["discription"],
        startPoint: AddressModel.fromJson(json["start_point"]),
        endPoint: AddressModel.fromJson(json["end_point"]),
        price: json["price"],
        currency: CurrencyModel.fromJson(json["currency"]),
        dateTime: DateTime.parse(json["DateTime"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}
