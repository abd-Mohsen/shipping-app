import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/bank_details_model.dart';
import 'package:shipment/models/branch_model.dart';
import 'package:shipment/models/company_stats_model.dart';
import 'package:shipment/models/employee_model.dart';
import 'package:shipment/models/extra_info_model.dart';
import 'package:shipment/models/governorate_model.dart';
import 'package:shipment/models/invoice_model.dart';
import 'package:shipment/models/location_model.dart';
import 'package:shipment/models/location_search_model.dart';
import 'package:shipment/models/make_order_model.dart';
import 'package:shipment/models/mini_order_model.dart';
import 'package:shipment/models/my_address_model.dart';
import 'package:shipment/models/notification_model.dart';
import 'package:shipment/models/order_model.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/payment_selection_model.dart';
import 'package:shipment/models/transfer_details_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import '../main.dart';
import '../models/filter_data_model.dart';
import '../models/login_model.dart';
import '../models/order_model_2.dart';
import '../models/user_model.dart';
import '../models/vehicle_model.dart';

class RemoteServices {
  static Map<String, String> headers = {
    "Accept": "Application/json",
    "Content-Type": "application/json",
    "sent-from": "mobile",
  };

  static String? mapApiKey = dotenv.env['LOCATIONIQ_API_KEY'];
  static String? routeServiceApiKey = dotenv.env['OPEN_ROUTE_SERVICE_API_KEY'];

  static var client = http.Client();

  static Future<LoginModel?> register(
    String userName,
    String firstName,
    String lastName,
    String role,
    String phone,
    String password,
    String passwordConfirmation,
    String? companyName,
    String? otp,
    File? idFront,
    File? idRear,
    File? licenseFront,
    File? licenseRear,
  ) async {
    Map<String, String> body = {
      "first_name": firstName,
      "last_name": lastName,
      "middel_name": userName,
      "phone_number": phone,
      "password": password,
      "confirmation_password": passwordConfirmation,
      "role": role,
      "company_name": companyName ?? "null",
      "otp_code": otp ?? "null",
    };
    Map<String, File?> images = {
      "ID_photo_front": idFront,
      "ID_photo_rare": idRear,
      "driving_license_photo_front": licenseFront,
      "driving_license_photo_rare": licenseRear,
    };
    String? json = await api.requestWithFiles("auth/register/", images, body, auth: false, utf8Decode: false);
    if (json == null) return null;

    return LoginModel.fromJson(jsonDecode(json));
  }

  static Future<LoginModel?> login(String phone, String password) async {
    Map<String, dynamic> body = {
      "phone_number": phone,
      "password": password,
    };
    String? json = await api.postRequest("auth/token/", body, auth: false);
    if (json == null) return null;
    return LoginModel.fromJson(jsonDecode(json));
  }

  static Future<bool> logout() async {
    String? json = await api.postRequest("auth/logout/", {}, auth: true);
    return json != null;
  }

  static Future<UserModel?> fetchCurrentUser() async {
    String? json = await api.getRequest("get-user-info/", auth: true, showTimeout: false);
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json));
  }

  // static Future<String?> sendRegisterOtp() async {
  //   String? json = await api.getRequest("send-register-otp", auth: true);
  //   if (json == null) return null;
  //   return jsonDecode(json)["url"];
  // }
  //
  // static Future<bool> verifyRegisterOtp(String apiUrl, String otp) async {
  //   apiUrl = apiUrl.replaceFirst("$kHostIP/api/", "");
  //   print(apiUrl);
  //   Map<String, dynamic> body = {"otp": otp};
  //   String? json = await api.postRequest(apiUrl, body, auth: true);
  //   if (json == null) {
  //     Get.defaultDialog(
  //       titleStyle: const TextStyle(color: Colors.black),
  //       middleTextStyle: const TextStyle(color: Colors.black),
  //       backgroundColor: Colors.white,
  //       title: "خطأ",
  //       middleText: "يرجى التأكد من البيانات المدخلة و المحاولة مجدداً قد يكون الاتصال ضعيف ",
  //     );
  //     return false;
  //   }
  //   return true;
  // }

  static Future<bool> sendOtp(String phone) async {
    Map<String, dynamic> body = {"phone_number": phone};
    String? json = await api.postRequest("auth/send-otp/", body, auth: false);
    return json != null;
  }

  static Future<String?> verifyOtp(String phone, String otp) async {
    Map<String, dynamic> body = {"phone_number": phone, "otp": otp};
    String? json = await api.postRequest("auth/verify-otp/", body, auth: false);
    if (json == null) return null;
    return jsonDecode(json)["reset_token"];
  }

  static Future<bool> resetPassword(String resetToken, String password, String rePassword) async {
    Map<String, dynamic> body = {
      "reset_token": resetToken,
      "new_password": password,
      "confirm_password": rePassword,
    };
    String? json = await api.postRequest("auth/password-reset/", body, auth: false);
    return json != null;
  }

  static Future<LocationModel?> getAddressFromLatLng(double latitude, double longitude) async {
    String? json = await api.getRequest(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
      toMyServer: false,
      utf8Decode: false,
    );
    if (json == null) {
      json = await api.getRequest(
        "https://us1.locationiq.com/v1/reverse?key=$mapApiKey&lat=$latitude&lon=$longitude&accept-language=ar&format"
        "=json&",
        toMyServer: false,
        utf8Decode: false,
      );
      if (json == null) return null;
    }
    final data = jsonDecode(json);
    return LocationModel.fromJson(data["address"]);
  }

  static Future<List<LocationSearchModel>?> getLatLngFromQuery(String query) async {
    String? json = await api.getRequest(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&countrycodes=SY&limit=20',
      toMyServer: false,
      utf8Decode: false,
    );
    if (json == null) {
      json = await api.getRequest(
        "https://us1.locationiq.com/v1/search?key=$mapApiKey&q=$query&limit=19&countrycodes=sy"
        "&normalizeaddress=1&accept-language=ar&format=json&",
        toMyServer: false,
        utf8Decode: false,
      );
      if (json == null) return null;
    }
    return locationSearchModelFromJson(json);
  }

  static Future<bool> addAddress(AddressModel address) async {
    Map<String, dynamic> body = {
      "address": address.toJson(),
    };
    String? json = await api.postRequest("user_addresses/", body, auth: true);
    return json != null;
  }

  static Future<List<MyAddressModel>?> fetchMyAddresses() async {
    String? json = await api.getRequest("user_addresses/", auth: true);
    if (json == null) return null;
    return myAddressModelFromJson(json);
  }

  static Future<bool> deleteAddress(int id) async {
    bool json = await api.deleteRequest("user_addresses/$id", auth: true);
    return json;
  }

  static Future<List<PaymentMethodModel>?> fetchPaymentMethods() async {
    String? json = await api.getRequest("cstomer_payment_methods/", utf8Decode: false, auth: true);
    if (json == null) return null;
    return paymentMethodModelFromJson(json);
  }

  static Future<List<VehicleTypeModel>?> fetchVehicleType() async {
    String? json = await api.getRequest("get_vehicle_type/");
    if (json == null) return null;
    return vehicleTypeModelFromJson(json);
  }

  static Future<bool> makeOrder(body) async {
    String? json = await api.postRequest("customer_order/", body, auth: true, utf8Decode: true);
    return json != null;
  }

  static Future<bool> addVehicle(
    String ownerName,
    int vehicleTypeID,
    String vehicleRegistrationNumber,
    File? vehicleRegistrationPhoto,
    String role,
  ) async {
    Map<String, String> body = {
      "full_name_owner": ownerName,
      "vehicle_type": vehicleTypeID.toString(),
      "vehicle_registration_number": vehicleRegistrationNumber,
    };
    Map<String, File?> images = {
      "vehicle_registration_photo": vehicleRegistrationPhoto,
    };
    String? json = await api.requestWithFiles("$role/vehicles/", images, body, auth: true, utf8Decode: false);
    return json != null;
  }

  static Future<bool> editVehicle(
    int vehicleID,
    String ownerName,
    int vehicleTypeID,
    String vehicleRegistrationNumber,
    File? vehicleRegistrationPhoto,
    String role,
  ) async {
    Map<String, String> body = {
      "full_name_owner": ownerName,
      "vehicle_type": vehicleTypeID.toString(),
      "vehicle_registration_number": vehicleRegistrationNumber,
    };
    Map<String, File?> images = {
      "vehicle_registration_photo": vehicleRegistrationPhoto,
    };
    String? json = await api.requestWithFiles(
        "$role/vehicles/$vehicleID/", methodType: "PUT", images, body, auth: true, utf8Decode: false);
    return json != null;
  }

  static Future<List<VehicleModel>?> fetchDriverVehicles(String role) async {
    String? json = await api.getRequest("$role/vehicles/", auth: true);
    if (json == null) return null;
    return vehicleModelFromJson(json);
  }

  static Future<List<VehicleModel>?> fetchCompanyVehicles() async {
    String? json = await api.getRequest("company/vehicles/", auth: true);
    if (json == null) return null;
    return vehicleModelFromJson(json);
  }

  static Future<bool> deleteVehicle(int id, String role) async {
    bool json = await api.deleteRequest("$role/vehicles/$id/", auth: true);
    return json;
  }

  static Future<bool> deleteCustomerOrder(int id) async {
    bool json = await api.deleteRequest("customer_order/$id/", auth: true);
    return json;
  }

  static Future<List<GovernorateModel>?> fetchGovernorates() async {
    String? json = await api.getRequest("get_governorate/", auth: true, showTimeout: false);
    if (json == null) return null;
    return governorateModelFromJson(json);
  }

  static Future<bool> editOrder(body, id) async {
    String? json = await api.putRequest("customer_order/$id/", body, auth: true);
    return json != null;
  }

  static Future<bool> addOrderPaymentMethods(body) async {
    String? json = await api.postRequest("cstomer_payment_methods/", body, auth: true);
    return json != null;
  }

  static Future<bool> deleteOrderPaymentMethod(id) async {
    return await api.deleteRequest("cstomer_payment_methods/$id/", auth: true);
  }

  static Future<bool> addEmployee(String phoneNumber) async {
    String? json = await api.postRequest(
      "auth/employee-register/",
      {"phone_number": phoneNumber},
      auth: true,
    );
    return json != null;
  }

  static Future<bool> editProfile({
    String? firstName,
    String? lastName,
    String? companyName,
    File? idFront,
    File? idRear,
    File? licenseFront,
    File? licenseRear,
  }) async {
    Map<String, String> body = {
      "first_name": firstName ?? "",
      "last_name": lastName ?? "",
      "company_name": companyName ?? "",
    };
    Map<String, File?> images = {
      "ID_photo_front": idFront,
      "ID_photo_rare": idRear,
      "driving_license_photo_front": licenseFront,
      "driving_license_photo_rare": licenseRear,
    };
    String? json =
        await api.requestWithFiles("auth/profile/", images, body, auth: true, utf8Decode: false, methodType: "PUT");
    return json != null;
  }

  static Future<bool> driverAcceptOrder(int orderID) async {
    String? json = await api.postRequest("driver_order/$orderID/accept/", {}, auth: true);
    return json != null;
  }

  static Future<bool> customerAcceptOrder(int orderID, int applicationID) async {
    String? json = await api.postRequest(
      "customer_order/$orderID/confirm/",
      {"application_id": applicationID},
      auth: true,
    );
    return json != null;
  }

  static Future<bool> customerRejectOrder(int orderID, int applicationID) async {
    String? json = await api.postRequest(
      "customer_order/$orderID/reject/",
      {"application_id": applicationID},
      auth: true,
    );
    return json != null;
  }

  static Future<bool> rejectOrder(int orderID, int applicationID) async {
    String? json = await api.postRequest(
      "customer_order/$orderID/reject/",
      {"application_id": applicationID},
      auth: true,
    );
    return json != null;
  }

  static Future<bool> driverConfirmOrder(
    int orderID,
    int paymentID,
    String fullName,
    String accountDetails,
    String phoneNumber,
  ) async {
    String? json = await api.postRequest(
      "driver_order/$orderID/confirm/",
      {
        "payment_method": {
          "order_payment_id": paymentID,
          "full_name": fullName,
          "account_details": accountDetails,
          "phone_number": phoneNumber,
        }
      },
      auth: true,
    );
    return json != null;
  }

  static Future<List<MiniOrderModel>?> fetchDriverCurrOrders() async {
    String? json = await api.getRequest("cache_order_data/", auth: true);
    if (json == null) return null;
    return miniOrderModelFromJson(json);
  }

  static Future<List<EmployeeModel>?> fetchMyEmployees() async {
    String? json = await api.getRequest("employees/", auth: true);
    if (json == null) return null;
    return employeeModelFromJson(json);
  }

  static Future<bool> deleteEmployee(int id) async {
    bool json = await api.deleteRequest("employees/$id/", auth: true);
    return json;
  }

  static Future<bool> subscribeFCM(String deviceToken) async {
    String? json = await api.postRequest(
      "$kHostIP/en/register-device/",
      {"token": deviceToken},
      auth: true,
      toMyServer: false,
    );
    return json != null;
  }

  static Future<CompanyStatsModel?> fetchCompanyStats() async {
    String? json = await api.getRequest("statistic/?days=0&order_status=approved&order_status=processing", auth: true);
    if (json == null) return null;
    return CompanyStatsModel.fromJson(jsonDecode(json));
  }

  static Future<bool> driverBeginOrder(int orderID) async {
    String? json = await api.postRequest("driver_order/$orderID/start/", {}, auth: true);
    return json != null;
  }

  static Future<bool> driverFinishOrder(int orderID) async {
    String? json = await api.postRequest("driver_order/$orderID/finish/", {}, auth: true);
    return json != null;
  }

  static Future<bool> companyAcceptOrder(int orderID, int? employeeID) async {
    String? json = await api.postRequest(
      "company_order/$orderID/accept/",
      {
        if (employeeID != null) "employee_id": employeeID,
      },
      auth: true,
    );
    return json != null;
  }

  //

  static Future<Map<String, List?>?> fetchAvailableVehiclesAndEmployees() async {
    String? json = await api.getRequest("get_avaliable_employees_vehicles/", auth: true);
    if (json == null) return null;
    Map decodedJson = jsonDecode(json);
    List availableVehicles = vehicleModelFromJson(jsonEncode(decodedJson["vehicles"]));
    List? availableEmployees =
        decodedJson["employees"] == null ? null : employeeModelFromJson(jsonEncode(decodedJson["employees"]));
    return {
      "vehicles": availableVehicles,
      "employees": availableEmployees,
    };
  }

  static Future<bool> companyConfirmOrder(
    int orderID,
    int paymentID,
    String fullName,
    String accountDetails,
    String phoneNumber,
  ) async {
    String? json = await api.postRequest(
      "company_order/$orderID/confirm/",
      {
        "payment_method": {
          "order_payment_id": paymentID,
          "full_name": fullName,
          "account_details": accountDetails,
          "phone_number": phoneNumber,
        }
      },
      auth: true,
    );
    return json != null;
  }

  static Future<bool> companyBeginOrder(int orderID) async {
    String? json = await api.postRequest("company_order/$orderID/start/", {}, auth: true);
    return json != null;
  }

  static Future<bool> companyFinishOrder(int orderID) async {
    String? json = await api.postRequest("company_order/$orderID/finish/", {}, auth: true);
    return json != null;
  }

  static Future<bool> customerCancelOrder(int orderID) async {
    String? json = await api.postRequest("customer_order/$orderID/cancel/", {}, auth: true);
    return json != null;
  }

  static Future<bool> driverCancelOrder(int orderID) async {
    String? json = await api.postRequest("driver_order/$orderID/cancel/", {}, auth: true);
    return json != null;
  }

  static Future<bool> companyCancelOrder(int orderID) async {
    String? json = await api.postRequest("company_order/$orderID/cancel/", {}, auth: true);
    return json != null;
  }

  static Future<Map<String, dynamic>?> fetchNotifications({int page = 1}) async {
    String? json = await api.getRequest("notifications/?page=$page", auth: true);
    if (json == null) return null;
    return {
      "notifications": notificationModelFromJson(json),
      "unread_count": jsonDecode(json)["total_count_unread"],
    };
  }

  static Future<bool> changePassword(String oldPass, String newPass, String reNewPass) async {
    Map<String, dynamic> body = {
      "old_password": oldPass,
      "new_password": newPass,
      "confirm_password": reNewPass,
    };
    String? json = await api.postRequest("auth/change-password/", body, auth: true);
    return json != null;
  }

  static Future<List<BranchModel>?> fetchBranches({int page = 1}) async {
    String? json = await api.getRequest(
      "get_branchs/?page=$page",
      auth: true,
    );
    if (json == null) return null;
    return branchModelFromJson(json);
  }

  static Future<List<InvoiceModel>?> fetchInvoices() async {
    String? json = await api.getRequest(
      "user_payment_history/",
      auth: true,
    );
    if (json == null) return null;
    return invoiceModelFromJson(json);
  }

  static Future<ExtraInfoModel?> fetchOrdersExtraInfo() async {
    String? json = await api.getRequest(
      "order-extra-info/",
      auth: true,
    );
    if (json == null) return null;
    return ExtraInfoModel.fromJson(jsonDecode(json));
  }

  static Future<MakeOrderModel?> fetchMakeOrderInfo() async {
    String? json = await api.getRequest(
      "orders/form-options/",
      auth: true,
      //utf8Decode: true,
    );
    if (json == null) return null;
    return MakeOrderModel.fromJson(jsonDecode(json));
  }

  // static Future<Map<String, List?>?> fetchBankDetails() async {
  //   String? json = await api.getRequest(
  //     "payments-admin/",
  //     auth: true,
  //   );
  //   if (json == null) return null;
  //   Map decodedJson = jsonDecode(json);
  //   List bankAccounts = bankDetailsModelFromJson(
  //     jsonEncode(decodedJson["bank_accounts"]),
  //   );
  //   List moneyTransferNumbers = transferDetailsModelFromJson(
  //     jsonEncode(decodedJson["phone_numbers"]),
  //   );

  static Future<List<BankDetailsModel>?> fetchBankPaymentsDetails() async {
    String? json = await api.getRequest("payments-details/admin/bank_account/", auth: true);
    if (json == null) return null;
    return bankDetailsModelFromJson(json);
  }

  static Future<List<TransferDetailsModel>?> fetchMoneyTransferPaymentsDetails() async {
    String? json = await api.getRequest("payments-details/admin/money_transfer/", auth: true);
    if (json == null) return null;
    return transferDetailsModelFromJson(json);
  }

  // static Future<List<PaymentSelectionModel>?> fetchPaymentDetailsSelectionOptions() async {
  //   String? json = await api.getRequest("payment-methods/admin/", auth: true);
  //   if (json == null) return null;
  //   return paymentSelectionModelFromJson(jsonEncode(json));
  // }

  static Future<List<PaymentSelectionModel>?> fetchPaymentDetailsSelectionOptions() async {
    String? json = await api.getRequest("payment-methods/admin/", auth: true);
    if (json == null) return null;
    return paymentSelectionModelFromJson(json);
  }

  static Future<OrderModel?> getSingleOrder(int id, String role) async {
    Map<String, String> prefix = {
      "customer": "customer_order",
      "driver": "driver_order",
      "company": "company_order",
      "company_employee": "company_order",
    };
    String? json = await api.getRequest("${prefix[role] ?? ""}/$id/", auth: true);
    if (json == null) return null;
    return OrderModel.fromJson(jsonDecode(json));
  }

  static Future<List<OrderModel2>?> fetchMyOrders({
    required List<String> types,
    required String role,
    int page = 1,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    int? vehicleType,
    int? governorate,
    int? currency,
  }) async {
    String addedTypes = "";
    for (String type in types) {
      addedTypes += "&order_status=$type";
    }
    if (searchQuery != null && searchQuery.isNotEmpty) addedTypes += "&search=$searchQuery";
    if (minPrice != null) addedTypes += "&min_price=$minPrice";
    if (maxPrice != null) addedTypes += "&max_price=$maxPrice";
    if (vehicleType != null) addedTypes += "&type_vehicle=$vehicleType";
    if (governorate != null) addedTypes += "&order_location=$governorate";
    if (currency != null) addedTypes += "&currency_id=$currency";
    String? json = await api.getRequest("${role}_order/?$addedTypes&page=$page", auth: true);
    if (json == null) return null;
    return orderModel2FromJson(json);
  }

  static Future<List<OrderModel2>?> fetchExploreOrders({
    required int governorateID,
    required String role,
    int page = 1,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    int? vehicleType,
    int? governorate,
    int? currency,
  }) async {
    String addedTypes = "";
    for (String type in ["available", "waiting_approval"]) {
      addedTypes += "&order_status=$type";
    }
    if (searchQuery != null && searchQuery.isNotEmpty) addedTypes += "&search=$searchQuery";
    if (minPrice != null) addedTypes += "&min_price=$minPrice";
    if (maxPrice != null) addedTypes += "&max_price=$maxPrice";
    if (vehicleType != null) addedTypes += "&type_vehicle=$vehicleType";
    if (governorate != null) addedTypes += "&order_location=$governorate";
    if (currency != null) addedTypes += "&currency_id=$currency";
    String? json = await api.getRequest(
      "${role}_order/?order_location=$governorateID&$addedTypes&page=$page",
      auth: true,
    );
    if (json == null) return null;
    return orderModel2FromJson(json);
  }

  static Future<FilterDataModel?> fetchFilterInfo() async {
    String? json = await api.getRequest(
      "filter_data/",
      auth: true,
      //utf8Decode: true,
    );
    if (json == null) return null;
    return FilterDataModel.fromJson(jsonDecode(json));
  }

  static Future<bool> readNotification(int id) async {
    String? json = await api.postRequest("notifications/$id", {}, auth: true);
    return json != null;
  }

  static Future<bool> unAssignVehicle(int id) async {
    String? json = await api.putRequest(
      "company/Unassign-vehicle/",
      {"vehicle_id": id.toString()},
      auth: true,
      patch: true,
    );
    return json != null;
  }

  static Future<bool> assignVehicle(int driverID, int vehicleID) async {
    String? json = await api.putRequest(
      "company/assign-vehicle/",
      {
        "driver_id": driverID.toString(),
        "vehicle_id": vehicleID.toString(),
      },
      auth: true,
      patch: true,
    );
    return json != null;
  }

  static Future<bool> toggleEmployee(int id, bool value) async {
    String? json = await api.putRequest(
      "employees/$id/",
      {"can_accept_orders": value},
      auth: true,
      patch: true,
    );
    return json != null;
  }

  static Future<bool> allowPhone(int orderID, int applicationID) async {
    Map<String, dynamic> body = {"application_id": applicationID};
    String? json = await api.postRequest("customer_order/$orderID/allow-phone-visibility/", body, auth: true);
    return json != null;
  }

  static Future<bool> customerRateOrder(int orderID, String comment, int rating) async {
    String? json = await api.postRequest(
      "driver-rating/",
      {
        "order": orderID,
        "rating": rating,
        "comment": comment,
      },
      auth: true,
    );
    return json != null;
  }

  static Future<int?> getRemainingCancels() async {
    String? json = await api.getRequest("user-cancel-count/", auth: true);
    return json == null ? null : jsonDecode(json)["cancel_count"];
  }

  static Future<List<LatLng>?> getRoadPoints({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    String? json = await api.getRequest(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$routeServiceApiKey&start=${startLng},${startLat}&end=${endLng},${endLat}',
      // {
      //   "coordinates": [
      //     [startLng, startLat], // Notice: lng first, then lat
      //     [endLng, endLat]
      //   ],
      // },
      toMyServer: false,
      auth: false,
      utf8Decode: false,
      customHeaders: {
        'Accept': 'application/geo+json',
      },
    );

    if (json == null) return null;

    final data = jsonDecode(json);
    final List<dynamic> points = data['features'][0]['geometry']['coordinates'];
    return points.map((p) => LatLng(p[1], p[0])).toList();
  }

  static Future<double?> distanceBetween2Points({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    final body = {
      "coordinates": [
        [startLng, startLat],
        [endLng, endLat]
      ],
      "radiuses": [500, 500], // optional, meters: expand radius to catch nearby roads
    };

    String? json = await api.postRequest(
      'https://api.openrouteservice.org/v2/directions/driving-car',
      body,
      toMyServer: false,
      auth: false,
      utf8Decode: true,
      customHeaders: {
        'Authorization': routeServiceApiKey ?? "",
        'Content-Type': 'application/json',
        'Accept': 'application/geo+json',
      },
    );

    if (json == null) return null;

    final data = jsonDecode(json);
    final distanceInMeters = data['routes'][0]['summary']['distance'];
    return distanceInMeters;
  }
}
