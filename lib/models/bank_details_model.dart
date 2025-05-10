import 'dart:convert';

List<BankDetailsModel> bankDetailsModelFromJson(String str) =>
    List<BankDetailsModel>.from(json.decode(str)["bank_accounts"].map((x) => BankDetailsModel.fromJson(x)));

String bankDetailsModelToJson(List<BankDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BankDetailsModel {
  final String fullName;
  final String accountDetails;

  BankDetailsModel({
    required this.fullName,
    required this.accountDetails,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) => BankDetailsModel(
        fullName: json["full_name"],
        accountDetails: json["account_details"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "account_details": accountDetails,
      };
}
