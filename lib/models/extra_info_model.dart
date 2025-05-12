import 'dart:convert';

ExtraInfoModel extraInfoModelFromJson(String str) => ExtraInfoModel.fromJson(json.decode(str));

String extraInfoModelToJson(ExtraInfoModel data) => json.encode(data.toJson());

class ExtraInfoModel {
  final List<String> orderExtraInfo;

  ExtraInfoModel({
    required this.orderExtraInfo,
  });

  factory ExtraInfoModel.fromJson(Map<String, dynamic> json) => ExtraInfoModel(
        orderExtraInfo: List<String>.from(json["order_extra_info"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "order_extra_info": List<dynamic>.from(orderExtraInfo.map((x) => x)),
      };
}
