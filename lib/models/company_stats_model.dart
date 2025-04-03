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
  final int availableDrivers; // todo: make int
  final int availableVehicle; //todo: make int

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

// class LastWeekOrders {
//   final int monday;
//   final int tuesday;
//   final int wednesday;
//   final int thursday;
//   final int friday;
//   final int saturday;
//   final int sunday;
//
//   LastWeekOrders({
//     required this.monday,
//     required this.tuesday,
//     required this.wednesday,
//     required this.thursday,
//     required this.friday,
//     required this.saturday,
//     required this.sunday,
//   });
//
//   factory LastWeekOrders.fromJson(Map<String, dynamic> json) => LastWeekOrders(
//         monday: json["Monday"],
//         tuesday: json["Tuesday"],
//         wednesday: json["Wednesday"],
//         thursday: json["Thursday"],
//         friday: json["Friday"],
//         saturday: json["Saturday"],
//         sunday: json["Sunday"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "Monday": monday,
//         "Tuesday": tuesday,
//         "Wednesday": wednesday,
//         "Thursday": thursday,
//         "Friday": friday,
//         "Saturday": saturday,
//         "Sunday": sunday,
//       };
// }

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
