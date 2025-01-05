import 'dart:convert';

import 'address_model.dart';

List<LocationModel> locationModelFromJson(String str) =>
    List<LocationModel>.from(json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  final String? road;
  final String? neighbourhood;
  final String? suburb;
  final String? city;
  final String? town;
  final String? subDistrict;
  final String? district;
  final String? state;
  final String? country;

  LocationModel({
    required this.road,
    required this.neighbourhood,
    required this.suburb,
    required this.city,
    required this.town,
    required this.subDistrict,
    required this.district,
    required this.state,
    required this.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        road: json["road"],
        neighbourhood: json["neighbourhood"],
        suburb: json["suburb"],
        city: json["city"]?.replaceFirst("بلدية ", ""),
        town: json["town"],
        subDistrict: json["subdistrict"],
        district: json["district"],
        state: json["state"]?.replaceFirst("محافظة ", ""),
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "road": road,
        "neighbourhood": neighbourhood,
        "suburb": suburb,
        "city": city,
        "town": town,
        "subdistrict": subDistrict,
        "district": district,
        "state": state,
        "country": country,
      };

  AddressModel addressEncoder() {
    List<String?> steps = [city, town, road];
    AddressModel result = AddressModel(name: state!, child: null);
    AddressModel current = result;

    for (String? step in steps) {
      if (step == null) continue;
      current.child = AddressModel(name: step, child: null);
      current = current.child!;
    }
    return result;
  }
}
