import 'dart:convert';

import 'package:shipment/models/currency_model.dart';

List<BalanceModel> balanceModelFromJson(String str) =>
    List<BalanceModel>.from(json.decode(str).map((x) => BalanceModel.fromJson(x)));

String balanceModelToJson(List<BalanceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BalanceModel {
  final CurrencyModel currency;
  final String amount;

  BalanceModel({
    required this.currency,
    required this.amount,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
        currency: CurrencyModel.fromJson(json["currency"]),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency.toJson(),
        "amount": amount,
      };
}
