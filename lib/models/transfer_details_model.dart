import 'dart:convert';

List<TransferDetailsModel> transferDetailsModelFromJson(String str) =>
    List<TransferDetailsModel>.from(json.decode(str).map((x) => TransferDetailsModel.fromJson(x)));

class TransferDetailsModel {
  final String fullName;
  final String phone;

  TransferDetailsModel({
    required this.fullName,
    required this.phone,
  });

  factory TransferDetailsModel.fromJson(Map<String, dynamic> json) => TransferDetailsModel(
        fullName: json["full_name"],
        phone: json["phone_number"],
      );
}
