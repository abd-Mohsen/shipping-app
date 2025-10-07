import 'dart:convert';

List<MiniVehicleModel> miniVehicleModelFromJson(String str) =>
    List<MiniVehicleModel>.from(json.decode(str).map((x) => MiniVehicleModel.fromJson(x)));

String miniVehicleModelToJson(List<MiniVehicleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MiniVehicleModel {
  final int id;
  final String vehicleRegistrationNumber;
  final String vehicleType;

  MiniVehicleModel({
    required this.id,
    required this.vehicleRegistrationNumber,
    required this.vehicleType,
  });

  factory MiniVehicleModel.fromJson(Map<String, dynamic> json) => MiniVehicleModel(
        id: json["id"],
        vehicleRegistrationNumber: json["vehicle_registration_number"].toString(),
        vehicleType: json["vehicle_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_registration_number": vehicleRegistrationNumber,
        "vehicle_type": vehicleType,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MiniVehicleModel && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "#$vehicleRegistrationNumber $vehicleType";
  }
}
