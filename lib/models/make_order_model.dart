import 'dart:convert';

import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:shipment/models/weight_unit_model.dart';

import 'currency_model.dart';

MakeOrderModel makeOrderModelFromJson(String str) => MakeOrderModel.fromJson(json.decode(str));

String makeOrderModelToJson(MakeOrderModel data) => json.encode(data.toJson());

class MakeOrderModel {
  final List<WeightUnitModel> weightUnits;
  final List<VehicleTypeModel> vehicleTypes;
  final List<CurrencyModel> currencies;
  final List<OrderExtraInfoModel> orderExtraInfo;
  final List<PaymentMethodModel> paymentMethods;
  final double customerCommissionPercentage;

  MakeOrderModel({
    required this.weightUnits,
    required this.vehicleTypes,
    required this.currencies,
    required this.orderExtraInfo,
    required this.paymentMethods,
    required this.customerCommissionPercentage,
  });

  factory MakeOrderModel.fromJson(Map<String, dynamic> json) => MakeOrderModel(
        weightUnits: List<WeightUnitModel>.from(json["weight_units"].map((x) => WeightUnitModel.fromJson(x))),
        vehicleTypes: List<VehicleTypeModel>.from(json["type_vehicles"].map((x) => VehicleTypeModel.fromJson(x))),
        currencies: List<CurrencyModel>.from(json["currencies"].map((x) => CurrencyModel.fromJson(x))),
        orderExtraInfo:
            List<OrderExtraInfoModel>.from(json["order_extra_info"].map((x) => OrderExtraInfoModel.fromJson(x))),
        paymentMethods:
            List<PaymentMethodModel>.from(json["payment_methods"].map((x) => PaymentMethodModel.fromJson(x))),
        customerCommissionPercentage: json["customer_commission_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "weight_units": List<dynamic>.from(weightUnits.map((x) => x.toJson())),
        "type_vehicles": List<dynamic>.from(vehicleTypes.map((x) => x.toJson())),
        "currencies": List<dynamic>.from(currencies.map((x) => x.toJson())),
        "order_extra_info": List<dynamic>.from(orderExtraInfo.map((x) => x.toJson())),
        "payment_methods": List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "customer_commission_percentage": customerCommissionPercentage,
      };
}

class OrderExtraInfoModel {
  final int id;
  final String name;

  OrderExtraInfoModel({
    required this.id,
    required this.name,
  });

  factory OrderExtraInfoModel.fromJson(Map<String, dynamic> json) => OrderExtraInfoModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderExtraInfoModel && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "$id $name";
  }
}
