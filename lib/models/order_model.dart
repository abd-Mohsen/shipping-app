import 'dart:convert';

import 'package:jiffy/jiffy.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/application_model.dart';
import 'package:shipment/models/currency_model.dart';
import 'package:shipment/models/make_order_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str)["results"].map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  final int id;
  final OrderOwner? orderOwner;
  final ApplicationModel? acceptedApplication;
  final VehicleTypeModel typeVehicle;
  final OrderLocation? orderLocation;
  final String description;
  final AddressModel startPoint;
  final AddressModel endPoint;
  final double weight;
  final String weightUnit;
  final double price;
  final double priceUsdEquivalent;
  final CurrencyModel currency;
  final List<OrderExtraInfoModel> extraInfo;
  final DateTime dateTime;
  final String? otherInfo;
  final String status;
  final bool ownerApproved;
  final bool driverApproved;
  final List<PaymentMethod> paymentMethods;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool customerWannaCancel;
  final bool driverWannaCancel;
  final List<ApplicationModel> driversApplications;

  OrderModel({
    required this.id,
    required this.orderOwner,
    required this.acceptedApplication,
    required this.typeVehicle,
    required this.orderLocation,
    required this.description,
    required this.startPoint,
    required this.endPoint,
    required this.weight,
    required this.weightUnit,
    required this.price,
    required this.priceUsdEquivalent,
    required this.currency,
    required this.extraInfo,
    required this.dateTime,
    required this.otherInfo,
    required this.status,
    required this.ownerApproved,
    required this.driverApproved,
    required this.paymentMethods,
    required this.createdAt,
    required this.updatedAt,
    required this.customerWannaCancel,
    required this.driverWannaCancel,
    required this.driversApplications,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        orderOwner: OrderOwner.fromJson(json["order_owner"]),
        acceptedApplication:
            json["accepted_application"] == null ? null : ApplicationModel.fromJson(json["accepted_application"]),
        typeVehicle: VehicleTypeModel.fromJson(json["type_vehicle"]),
        description: json["discription"],
        orderLocation: json["order_location"] == null ? null : OrderLocation.fromJson(json["order_location"]),
        startPoint: AddressModel.fromJson(json["start_point"]),
        endPoint: AddressModel.fromJson(json["end_point"]),
        weight: json["weight"],
        weightUnit: json["weight_unit"],
        price: json["price"],
        priceUsdEquivalent: json["price_usd_equivalent"],
        currency: CurrencyModel.fromJson(json["currency"]),
        extraInfo: List<OrderExtraInfoModel>.from(json["order_extra_info"].map((x) => OrderExtraInfoModel.fromJson(x))),
        dateTime: DateTime.parse(json["DateTime"]),
        otherInfo: json["other_info"],
        status: json["status"],
        ownerApproved: json["owner_is_approved"],
        driverApproved: json["driver_is_approved"],
        paymentMethods: List<PaymentMethod>.from(json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        customerWannaCancel: json["customer_wanna_cancel"],
        driverWannaCancel: json["driver_wanna_cancel"],
        driversApplications: json["drivers_applications"] == null
            ? []
            : List<ApplicationModel>.from(json["drivers_applications"].map((x) => ApplicationModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_owner": orderOwner!.toJson(),
        "accepted_application": acceptedApplication,
        "type_vehicle": typeVehicle.toJson(),
        "discription": description,
        "order_location": orderLocation!.toJson(),
        "start_point": startPoint.toJson(),
        "end_point": endPoint.toJson(),
        "weight": weight,
        "weight_unit": weightUnit,
        "price": price,
        "price_usd_equivalent": priceUsdEquivalent,
        "currency": currency.toJson(),
        "order_extra_info": List<dynamic>.from(extraInfo.map((x) => x)),
        "DateTime": dateTime.toIso8601String(),
        "other_info": otherInfo,
        "status": status,
        "owner_is_approved": ownerApproved,
        "driver_is_approved": driverApproved,
        "payment_methods": List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "customer_wanna_cancel": customerWannaCancel,
        "driver_wanna_cancel": driverWannaCancel,
        "drivers_applications": List<dynamic>.from(driversApplications!.map((x) => x)),
      };

  String formatExtraInfo() {
    String res = "";
    for (String info in extraInfo.map((e) => e.name).toList()) {
      res += "$info\n";
    }
    return res;
  }

  String shortAddress() {
    return "${startPoint.governorate} - ${endPoint.governorate}";
  }

  String fullDate() {
    return "${Jiffy.parseFromDateTime(dateTime).format(pattern: "d / M / y")} - ${Jiffy.parseFromDateTime(dateTime).jm}";
  }

  String shortDate() {
    return Jiffy.parseFromDateTime(dateTime).format(pattern: "d / M / y");
  }

  String fullCreationDate() {
    return "${Jiffy.parseFromDateTime(createdAt).format(pattern: "d / M / y")} - ${Jiffy.parseFromDateTime(createdAt).jm}";
  }

  String shortCreationDate() {
    return Jiffy.parseFromDateTime(createdAt).format(pattern: "d / M / y");
  }
}

class OrderLocation {
  final int id;
  final String name;

  OrderLocation({
    required this.id,
    required this.name,
  });

  factory OrderLocation.fromJson(Map<String, dynamic> json) => OrderLocation(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class OrderOwner {
  final String name;
  final String phoneNumber;

  OrderOwner({
    required this.name,
    required this.phoneNumber,
  });

  factory OrderOwner.fromJson(Map<String, dynamic> json) => OrderOwner(
        name: json["name"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
      };
}

class PaymentMethod {
  final int? id;
  final Payment payment;
  final bool isActive;

  PaymentMethod({
    required this.id,
    required this.payment,
    required this.isActive,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["order_payment_id"],
        payment: Payment.fromJson(json["payment"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "order_payment_id": id,
        "payment": payment.toJson(),
        "is_active": isActive,
      };
}

class Payment {
  final String methodName;
  final String? fullName;
  final String? phoneNumber;
  final String? accountDetails;
  final String? info;

  Payment({
    required this.methodName,
    required this.fullName,
    required this.phoneNumber,
    required this.accountDetails,
    required this.info,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        methodName: json["method_name"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        accountDetails: json["account_details"],
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "method_name": methodName,
        "info": info,
        "full_name": fullName,
        "account_details": accountDetails,
        "phone_number": phoneNumber,
      };
}
