import 'dart:convert';

import 'package:shipment/models/currency_model.dart';

import 'branch_model.dart';

List<InvoiceModel> invoiceModelFromJson(String str) =>
    List<InvoiceModel>.from(json.decode(str).map((x) => InvoiceModel.fromJson(x)));

String invoiceModelToJson(List<InvoiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvoiceModel {
  final int id;
  final double amount;
  final DateTime paymentDate;
  final BranchModel? branch;
  final CurrencyModel? currency;

  InvoiceModel({
    required this.id,
    required this.amount,
    required this.paymentDate,
    required this.branch,
    required this.currency,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        amount: json["amount"] ?? 0.0,
        paymentDate: DateTime.parse(json["payment_date"]),
        branch: json["branch"] == null ? null : BranchModel.fromJson(json["branch"]),
        currency: json["currency"] == null ? null : CurrencyModel.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "payment_date": paymentDate.toIso8601String(),
        "branch": branch!.toJson(),
      };

  String formatedAmount() {
    return "${amount.toStringAsFixed(2)} ${currency!.symbol}";
  }
}
