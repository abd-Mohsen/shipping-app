import 'dart:convert';

List<TransferDetailsModel> transferDetailsModelFromJson(String str) =>
    List<TransferDetailsModel>.from(json.decode(str)["phone_numbers"].map((x) => TransferDetailsModel.fromJson(x)));

// List<TransferDetailsModel> transferDetailsModelFromJson(String str) {
//   try {
//     // First decode the JSON string
//     final decodedJson = json.decode(str);
//
//     // Check if we have the expected structure
//     if (decodedJson is Map<String, dynamic> && decodedJson.containsKey('phone_numbers')) {
//       // Get the phone_numbers array
//       final phoneNumbers = decodedJson['phone_numbers'];
//
//       // Convert each item to TransferDetailsModel
//       if (phoneNumbers is List) {
//         return phoneNumbers.map((item) => TransferDetailsModel.fromJson(item)).toList();
//       }
//     }
//
//     throw FormatException('Invalid JSON format for TransferDetailsModel');
//   } catch (e) {
//     print('Error parsing transfer details: $e');
//     rethrow;
//   }
// }

class TransferDetailsModel {
  final String fullName;
  final String phone;

  TransferDetailsModel({
    required this.fullName,
    required this.phone,
  });

  factory TransferDetailsModel.fromJson(Map<String, dynamic> json) => TransferDetailsModel(
        fullName: json["full_name"],
        phone: json["phone_number"],
      );
}
