import 'dart:convert';

//todo: store lat, long somehow
List<AddressModel> addressModelFromJson(String str) =>
    List<AddressModel>.from(json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressModelToJson(List<AddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel {
  final int? id;
  final String name;
  AddressModel? child;

  AddressModel({
    this.id,
    required this.name,
    required this.child,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        name: json["name"],
        child: json["child"] == null ? null : AddressModel.fromJson(json["child"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "child": child?.toJson(),
      };

  @override
  String toString() {
    List<String> list = [];
    AddressModel? curr = this;
    while (curr != null) {
      list.add(curr.name);
      curr = curr.child;
    }
    return list.join(", ");
  }
}
