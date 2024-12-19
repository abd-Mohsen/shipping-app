import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
    String email,
    String password,
    String passwordConfirmation,
    String phone,
    String role,
    int? supervisorId,
  ) async {
    Map<String, dynamic> body = {
      "name": userName,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "role": role,
      "phone": phone,
      if (supervisorId != null) "supervisor_id": supervisorId,
    };
    String? json = await api.postRequest("register", body, auth: false);
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

  static Future<LoginModel?> login(String email, String password) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };
    String? json = await api.postRequest("login", body, auth: false);
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
    String? json = await api.getRequest("logout", auth: true);
    return json != null;
  }

  static Future<UserModel?> fetchCurrentUser() async {
    String? json = await api.getRequest("users/profile", auth: true, showTimeout: false);
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json));
  }

  static Future<String?> sendRegisterOtp() async {
    String? json = await api.getRequest("send-register-otp", auth: true);
    if (json == null) return null;
    return jsonDecode(json)["url"];
  }

  static Future<bool> verifyRegisterOtp(String apiUrl, String otp) async {
    apiUrl = apiUrl.replaceFirst("$kHostIP/api/", "");
    print(apiUrl);
    Map<String, dynamic> body = {"otp": otp};
    String? json = await api.postRequest(apiUrl, body, auth: true);
    if (json == null) {
      Get.defaultDialog(
        titleStyle: const TextStyle(color: Colors.black),
        middleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        title: "خطأ",
        middleText: "يرجى التأكد من البيانات المدخلة و المحاولة مجدداً قد يكون الاتصال ضعيف ",
      );
      return false;
    }
    return true;
  }

  static Future<bool> sendForgotPasswordOtp(String email) async {
    Map<String, dynamic> body = {"email": email};
    String? json = await api.postRequest("send-reset-otp", body, auth: false);
    return json != null;
  }

  static Future<String?> verifyForgotPasswordOtp(String email, String otp) async {
    Map<String, dynamic> body = {"email": email, "otp": otp};
    String? json = await api.postRequest("verify-reset-otp", body, auth: false);
    if (json == null) return null;
    return jsonDecode(json)["reset_token"];
  }

  static Future<bool> resetPassword(String email, String password, String resetToken) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "password_confirmation": password,
      "token": resetToken,
    };
    String? json = await api.postRequest("reset-password", body, auth: false);
    return json != null;
  }
}
