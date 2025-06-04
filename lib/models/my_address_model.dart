import 'dart:convert';

import 'package:shipment/models/address_model.dart';

List<MyAddressModel> myAddressModelFromJson(String str) =>
    List<MyAddressModel>.from(json.decode(str).map((x) => MyAddressModel.fromJson(x)));

String myAddressModelToJson(List<MyAddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyAddressModel {
  final int id;
  final AddressModel address;

  MyAddressModel({
    required this.id,
    required this.address,
  });

  factory MyAddressModel.fromJson(Map<String, dynamic> json) => MyAddressModel(
        id: json["id"],
        address: AddressModel.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address.toJson(),
      };
}
