import 'dart:convert';

List<PaymentMethodModel> paymentMethodModelFromJson(String str) =>
    List<PaymentMethodModel>.from(json.decode(str).map((x) => PaymentMethodModel.fromJson(x)));

String paymentMethodModelToJson(List<PaymentMethodModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentMethodModel {
  final int id;
  final String name;
  final String value;
  final String description;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.value,
    required this.description,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
        id: json["id"],
        name: json["name"],
        value: json["value"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "description": description,
      };
}
