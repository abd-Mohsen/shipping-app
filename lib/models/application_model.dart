import 'dart:convert';

List<ApplicationModel> applicationModelFromJson(String str) =>
    List<ApplicationModel>.from(json.decode(str).map((x) => ApplicationModel.fromJson(x)));

String applicationModelToJson(List<ApplicationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApplicationModel {
  final int id;
  final Driver driver;
  final int vehicle;
  final DateTime appliedAt;

  ApplicationModel({
    required this.id,
    required this.driver,
    required this.vehicle,
    required this.appliedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => ApplicationModel(
        id: json["id"],
        driver: Driver.fromJson(json["driver"]),
        vehicle: json["vehicle"],
        appliedAt: DateTime.parse(json["applied_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver": driver.toJson(),
        "vehicle": vehicle,
        "applied_at": appliedAt.toIso8601String(),
      };
}

class Driver {
  final int id;
  final String name;
  final String phoneNumber;
  final int overallRating;

  Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.overallRating,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        overallRating: json["overall_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "overall_rating": overallRating,
      };
}
