import 'dart:convert';

// List<PaymentSelectionModel> paymentSelectionModelFromJson(String str) =>
//     List<PaymentSelectionModel>.from(json.decode(str).map((x) => PaymentSelectionModel.fromJson(x)));

List<PaymentSelectionModel> paymentSelectionModelFromJson(dynamic jsonData) {
  try {
    // Handle case where jsonData is already decoded
    if (jsonData is String) {
      jsonData = jsonDecode(jsonData);
    }

    if (jsonData is List) {
      return jsonData.map((item) => PaymentSelectionModel.fromJson(item)).toList();
    }

    throw FormatException('Expected a JSON array but got ${jsonData.runtimeType}');
  } catch (e) {
    print('Error in paymentSelectionModelFromJson: $e');
    rethrow;
  }
}

String paymentSelectionModelToJson(List<PaymentSelectionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentSelectionModel {
  final int id;
  final String name;
  final String value;
  final String subtitle;

  PaymentSelectionModel({
    required this.id,
    required this.name,
    required this.value,
    required this.subtitle,
  });

  factory PaymentSelectionModel.fromJson(Map<String, dynamic> json) => PaymentSelectionModel(
        id: json["id"],
        name: json["name"],
        value: json["value"],
        subtitle: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "description": subtitle,
      };
}
