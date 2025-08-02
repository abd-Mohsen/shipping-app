import 'dart:convert';

AboutUsModel aboutUsModelFromJson(String str) => AboutUsModel.fromJson(json.decode(str));

String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());

class AboutUsModel {
  final int id;
  final String website;
  final String email;
  final String phone;
  final String landline;
  final String companyName;

  AboutUsModel({
    required this.id,
    required this.website,
    required this.email,
    required this.phone,
    required this.landline,
    required this.companyName,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        id: json["id"],
        website: json["website"],
        email: json["email"],
        phone: json["phone"],
        landline: json["landline"],
        companyName: json["company_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "website": website,
        "email": email,
        "phone": phone,
        "landline": landline,
        "company_name": companyName,
      };
}
