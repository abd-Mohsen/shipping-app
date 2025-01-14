import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/location_model.dart';
import 'package:shipment/models/payment_method_model.dart';

import '../constants.dart';
import '../main.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';

class RemoteServices {
  static Map<String, String> headers = {
    "Accept": "Application/json",
    "Content-Type": "application/json",
    "sent-from": "mobile",
  };

  static var client = http.Client();

  static Future<bool> register(
    String userName,
    String firstName,
    String lastName,
    String role,
    String phone,
    String password,
    String passwordConfirmation,
    String companyName,
    String numVehicle,
    File? idFront,
    File? idRear,
    File? licenseFront,
    File? licenseRear,
  ) async {
    Map<String, String> body = {
      "first_name": firstName,
      "last_name": lastName,
      "username": userName,
      "phone_number": phone,
      "password": password,
      "confirmation_password": passwordConfirmation,
      "role": role,
      "company_name": companyName,
      "vehicle_num": numVehicle,
      "members_num": "4",
    };
    Map<String, File?> images = {
      "ID_photo_front": idFront,
      "ID_photo_rare": idRear,
      "driving_license_photo_front": licenseFront,
      "driving_license_photo_rare": licenseRear,
    };
    String? json = await api.postRequestWithImages("auth/register/", images, body, auth: false);
    if (json == null) {
      Get.defaultDialog(
        titleStyle: const TextStyle(color: Colors.black),
        middleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        title: "خطأ",
        middleText: "يرجى المحاولة مجدداً, قد يكون البريد الالكتلاوني مستخدماً بالفعل",
      );
      return false;
    }
    return true;
  }

  static Future<LoginModel?> login(String phone, String password) async {
    Map<String, dynamic> body = {
      "phone_number": phone,
      "password": password,
    };
    String? json = await api.postRequest("auth/token/", body, auth: false);
    if (json == null) {
      Get.defaultDialog(
        titleStyle: const TextStyle(color: Colors.black),
        middleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        title: "خطأ",
        middleText: "يرجى التأكد من البيانات المدخلة و المحاولة مجدداً, قد يكون الاتصال ضعيف",
      );
      return null;
    }
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
    //todo: handle errors
    String? json = await api.getRequest(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
      toMyServer: false,
    );
    if (json == null) return null;
    final data = jsonDecode(json);
    return LocationModel.fromJson(data["address"]);
  }

  static Future<bool> addAddress(AddressModel address) async {
    Map<String, dynamic> body = {
      "address": [address.toJson()],
    };
    String? json = await api.postRequest("user_addresses/", body, auth: true);
    return json != null;
  }

  static Future<List<PaymentMethodModel>?> fetchPaymentMethods() async {
    String? json = await api.getRequest("get_payment_methods/", showTimeout: false);
    if (json == null) return null;
    return paymentMethodModelFromJson(json);
  }
}
