import 'dart:convert';

List<AddressModel> addressModelFromJson(String str) =>
    List<AddressModel>.from(json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressModelToJson(List<AddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel {
  final int? id;
  final String country;
  final String governorate;
  final String? city;
  final String? district;
  final String? street;
  final double latitude;
  final double longitude;

  AddressModel({
    this.id,
    required this.country,
    required this.governorate,
    required this.city,
    required this.district,
    required this.street,
    required this.latitude,
    required this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        country: json["country"],
        governorate: json["governorate"],
        city: json["city"],
        district: json["district"],
        street: json["street"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "governorate": governorate,
        "city": city,
        "district": district,
        "street": street,
        "latitude": latitude,
        "longitude": longitude,
      };

  @override
  String toString() {
    List<String?> names = [governorate, city, street];
    String res = "";

    for (String? name in names) {
      if (name != null) {
        res += name;
        res += ', ';
      }
    }
    res = res.substring(0, res.length - 2);
    return res;
  }
}
