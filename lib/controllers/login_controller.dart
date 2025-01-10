import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/views/customer_home_view.dart';
import 'package:shipment/views/driver_home_view.dart';

import '../models/login_model.dart';
import '../services/remote_services.dart';

class LoginController extends GetxController {
  @override
  void onClose() {
    // email.dispose();
    // password.dispose();
    super.onClose();
  }

  final GetStorage _getStorage = GetStorage();

  final phone = TextEditingController();
  final password = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility(bool value) {
    _passwordVisible = value;
    update();
  }

  void login() async {
    //todo: almost done, just check all cases
    if (isLoading) return; // todo (later): do this for every button, to not send multiple requests
    buttonPressed = true;
    bool isValid = loginFormKey.currentState!.validate();
    if (!isValid) return;
    toggleLoading(true);
    LoginModel? loginData = await RemoteServices.login(phone.text, password.text);
    if (loginData == null) {
      toggleLoading(false);
      return;
    }
    _getStorage.write("token", loginData.token);
    _getStorage.write("role", loginData.role.type);
    print(_getStorage.read("token"));
    if (loginData.role.type == "driver") {
      Get.offAll(() => const DriverHomeView());
    } else if (loginData.role.type == "customer") {
      Get.offAll(() => const CustomerHomeView());
    } else if (loginData.role.type == "company") {
      Get.offAll(() => const Placeholder());
    } else {
      print("wrong role");
      return; // other role
    }
    toggleLoading(false);
  }
}
