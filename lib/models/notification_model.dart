import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(json.decode(str)["results"].map((x) => NotificationModel.fromJson(x)));

class NotificationModel {
  final int id;
  final String title;
  final DateTime timestamp;
  final String content;
  final String? iconUrl;
  final String action;
  bool isRead;
  final int user;
  final ActionParams? actionParams;

  NotificationModel({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.content,
    required this.iconUrl,
    required this.action,
    required this.isRead,
    required this.user,
    required this.actionParams,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        title: json["title"]!,
        timestamp: DateTime.parse(json["timestamp"]),
        content: json["content"],
        iconUrl: json["icon_url"],
        action: json["action"] ?? "",
        isRead: json["is_read"],
        user: json["user"] ?? 0,
        actionParams: json["action_params"] == null ? null : ActionParams.fromJson(json["action_params"]),
      );

  void markAsRead() {
    isRead = true;
  }
}

class ActionParams {
  final int? orderId;

  ActionParams({
    required this.orderId,
  });

  factory ActionParams.fromJson(Map<String, dynamic> json) => ActionParams(
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
      };
}
