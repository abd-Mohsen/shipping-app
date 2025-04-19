import 'dart:convert';

List<LocationSearchModel> locationSearchModelFromJson(String str) =>
    List<LocationSearchModel>.from(json.decode(str).map((x) => LocationSearchModel.fromJson(x)));

String locationSearchModelToJson(List<LocationSearchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationSearchModel {
  final double lat;
  final double long;
  final String name;
  final String displayName;

  LocationSearchModel({
    required this.lat,
    required this.long,
    required this.name,
    required this.displayName,
  });

  factory LocationSearchModel.fromJson(Map<String, dynamic> json) => LocationSearchModel(
        lat: double.parse(json["lat"]),
        long: double.parse(json["lon"]),
        name: json["name"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": long,
        "name": name,
        "display_name": displayName,
      };
}
