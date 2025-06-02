import 'dart:convert';
import 'dart:math';

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

  Map<String, double> decodedOrdersPerCity(bool mock) {
    Map<String, double> res = {};

    List temp = List.from(mockPieChartData());

    if (mock) {
      temp.sort((a, b) => b.orderCount.compareTo(a.orderCount));
      for (OrdersPerCity ordersPerCity in temp) {
        res[ordersPerCity.orderLocationName] = ordersPerCity.orderCount.toDouble();
      }
    } else {
      ordersPerCity.sort((a, b) => b.orderCount.compareTo(a.orderCount));
      for (OrdersPerCity ordersPerCity in ordersPerCity) {
        res[ordersPerCity.orderLocationName] = ordersPerCity.orderCount.toDouble();
      }
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

  Map<String, dynamic> mockBarChartData() {
    Map<String, dynamic> res = {};
    for (String day in lastWeekOrders.keys) {
      res[day] = Random().nextInt(24).toDouble();
    }
    return res;
  }

  List<OrdersPerCity> mockPieChartData() {
    List<OrdersPerCity> res = [];
    res.add(OrdersPerCity(orderLocationName: "درعا", orderCount: 10));
    res.add(OrdersPerCity(orderLocationName: "حلب", orderCount: 20));
    res.add(OrdersPerCity(orderLocationName: "ريف دمشق", orderCount: 70));
    res.add(OrdersPerCity(orderLocationName: "حماة", orderCount: 30));
    res.add(OrdersPerCity(orderLocationName: "ادلب", orderCount: 30));
    res.add(OrdersPerCity(orderLocationName: "طرطوس", orderCount: 30));
    res.add(OrdersPerCity(orderLocationName: "دمشق", orderCount: 40));
    res.add(OrdersPerCity(orderLocationName: "اللادقية", orderCount: 30));
    res.add(OrdersPerCity(orderLocationName: "دير الزور", orderCount: 30));
    // res.add(OrdersPerCity(orderLocationName: "الحسكة", orderCount: 30));
    // res.add(OrdersPerCity(orderLocationName: "الرقة", orderCount: 30));
    res.add(OrdersPerCity(orderLocationName: "القنيطرة", orderCount: 30));
    res.add(OrdersPerCity(orderLocationName: "حمص", orderCount: 15));
    //res.add(OrdersPerCity(orderLocationName: "السويداء", orderCount: 30));
    return res;
  }
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
