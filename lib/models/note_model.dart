import 'dart:convert';

List<NoteModel> noteModelFromJson(String str) =>
    List<NoteModel>.from(json.decode(str).map((x) => NoteModel.fromJson(x)));

String noteModelToJson(List<NoteModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoteModel {
  final int id;
  final int order;
  final String note;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.order,
    required this.note,
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json["id"],
        order: json["order"],
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order": order,
        "note": note,
        "created_at": createdAt.toIso8601String(),
      };
}
