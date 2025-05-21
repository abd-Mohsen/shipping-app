import 'dart:convert';

import 'branch_model.dart';

List<InvoiceModel> invoiceModelFromJson(String str) =>
    List<InvoiceModel>.from(json.decode(str).map((x) => InvoiceModel.fromJson(x)));

String invoiceModelToJson(List<InvoiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvoiceModel {
  final int id;
  final String amount;
  final DateTime paymentDate;
  final BranchModel? branch;

  InvoiceModel({
    required this.id,
    required this.amount,
    required this.paymentDate,
    required this.branch,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        amount: json["amount"],
        paymentDate: DateTime.parse(json["payment_date"]),
        branch: json["branch"] == null ? null : BranchModel.fromJson(json["branch"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "payment_date": paymentDate.toIso8601String(),
        "branch": branch!.toJson(),
      };
}
