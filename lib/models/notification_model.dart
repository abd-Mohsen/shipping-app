import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(json.decode(str)["results"].map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  final int id;
  final String title;
  final DateTime timestamp;
  final String content;
  final String url;
  final String style;
  bool isRead;
  final int user;

  NotificationModel({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.content,
    required this.url,
    required this.style,
    required this.isRead,
    required this.user,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        title: json["title"]!,
        timestamp: DateTime.parse(json["timestamp"]),
        content: json["content"],
        url: json["url"] ?? "",
        style: json["style"],
        isRead: json["is_read"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "timestamp": timestamp.toIso8601String(),
        "content": content,
        "url": url,
        "style": style,
        "is_read": isRead,
        "user": user,
      };

  void markAsRead() {
    isRead = true;
  }
}
