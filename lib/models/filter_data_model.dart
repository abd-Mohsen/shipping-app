import 'dart:convert';

import 'package:shipment/models/governorate_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';

import 'currency_model.dart';

FilterDataModel filterDataModelFromJson(String str) => FilterDataModel.fromJson(json.decode(str));

class FilterDataModel {
  final List<GovernorateModel> governorates;
  final List<VehicleTypeModel> vehicleTypes;
  final List<CurrencyModel> currencies;

  FilterDataModel({
    required this.governorates,
    required this.vehicleTypes,
    required this.currencies,
  });

  factory FilterDataModel.fromJson(Map<String, dynamic> json) => FilterDataModel(
        governorates: List<GovernorateModel>.from(json["governorates"].map((x) => GovernorateModel.fromJson(x))),
        vehicleTypes: List<VehicleTypeModel>.from(json["type_vehicles"].map((x) => VehicleTypeModel.fromJson(x))),
        currencies: List<CurrencyModel>.from(json["currencies"].map((x) => CurrencyModel.fromJson(x))),
      );
}
