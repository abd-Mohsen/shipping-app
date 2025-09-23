import 'dart:convert';

import 'package:shipment/models/currency_model.dart';

List<BalanceModel> balanceModelFromJson(String str) =>
    List<BalanceModel>.from(json.decode(str).map((x) => BalanceModel.fromJson(x)));

String balanceModelToJson(List<BalanceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BalanceModel {
  final CurrencyModel currency;
  final String amount;
  final String reservedCommission;

  BalanceModel({
    required this.currency,
    required this.amount,
    required this.reservedCommission,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
        currency: CurrencyModel.fromJson(json["currency"]),
        amount: json["amount"],
        reservedCommission: json["reserved_commission"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency.toJson(),
        "amount": amount,
      };
}
