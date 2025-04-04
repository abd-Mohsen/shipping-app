import 'dart:convert';

CompanyStatsModel companyStatsModelFromJson(String str) => CompanyStatsModel.fromJson(json.decode(str));

String companyStatsModelToJson(CompanyStatsModel data) => json.encode(data.toJson());

class CompanyStatsModel {
  final String companyName;
  final int totalEmployees;
  final int totalVehicles;
  final int totalOrders;
  final List<OrdersPerCity> ordersPerCity;
  final Map<String, dynamic> lastWeekOrders;
  final int processingOrder;
  final int availableDrivers;
  final int availableVehicle;

  CompanyStatsModel({
    required this.companyName,
    required this.totalEmployees,
    required this.totalVehicles,
    required this.totalOrders,
    required this.ordersPerCity,
    required this.lastWeekOrders,
    required this.processingOrder,
    required this.availableDrivers,
    required this.availableVehicle,
  });

  factory CompanyStatsModel.fromJson(Map<String, dynamic> json) => CompanyStatsModel(
        companyName: json["company_name"],
        totalEmployees: json["total_employees"],
        totalVehicles: json["total_vehicles"],
        totalOrders: json["total_orders"],
        ordersPerCity: List<OrdersPerCity>.from(json["orders_per_city"].map((x) => OrdersPerCity.fromJson(x))),
        lastWeekOrders: json["last_week_orders"],
        processingOrder: json["processing_order"],
        availableDrivers: json["available_drivers_length"],
        availableVehicle: json["available_vehicles_length"],
      );

  Map<String, double> decodedOrdersPerCity() {
    Map<String, double> res = {};

    for (OrdersPerCity ordersPerCity in ordersPerCity) {
      res[ordersPerCity.orderLocationName] = ordersPerCity.orderCount.toDouble();
    }

    return res;
  }

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "total_employees": totalEmployees,
        "total_vehicles": totalVehicles,
        "total_orders": totalOrders,
        "orders_per_city": List<dynamic>.from(ordersPerCity.map((x) => x.toJson())),
        "last_week_orders": lastWeekOrders,
        "processing_order": processingOrder,
        "available_driver": availableDrivers,
        "available_vehicle": availableVehicle,
      };
}

class OrdersPerCity {
  final String orderLocationName;
  final int orderCount;

  OrdersPerCity({
    required this.orderLocationName,
    required this.orderCount,
  });

  factory OrdersPerCity.fromJson(Map<String, dynamic> json) => OrdersPerCity(
        orderLocationName: json["order_location__name"],
        orderCount: json["order_count"],
      );

  Map<String, dynamic> toJson() => {
        "order_location__name": orderLocationName,
        "order_count": orderCount,
      };
}
