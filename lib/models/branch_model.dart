import 'dart:convert';

import 'package:shipment/models/address_model.dart';

List<BranchModel> branchModelFromJson(String str) =>
    List<BranchModel>.from(json.decode(str)["results"].map((x) => BranchModel.fromJson(x)));

String branchModelToJson(List<BranchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BranchModel {
  final int id;
  final String name;
  final AddressModel address;
  final bool isActive;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.isActive,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: json["id"],
        name: json["name"],
        address: AddressModel.fromJson(json["address"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address.toJson(),
        "is_active": isActive,
      };
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
