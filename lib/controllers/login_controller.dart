import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/views/driver_home_view.dart';

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
    if (isLoading) return; // todo (later): do this for every button, to not send multiple requests
    buttonPressed = true;
    bool isValid = loginFormKey.currentState!.validate();
    if (!isValid) return;
    toggleLoading(true);
    // LoginModel? loginData = await RemoteServices.login(email.text, password.text);
    // if (loginData == null) {
    //   toggleLoading(false);
    //   return;
    // }
    // _getStorage.write("token", loginData.accessToken);
    // _getStorage.write("role", loginData.role);
    // print(_getStorage.read("token"));
    // if (loginData.role == "salesman") {
    //   Get.offAll(() => const HomeView());
    // } else if (loginData.role == "supervisor") {
    //   Get.offAll(() => const SupervisorView());
    // } else {
    //   return; // admin, show a message from backend (send a header that represents the platform)
    // }
    await Future.delayed(Duration(milliseconds: 1500));
    Get.offAll(() => const DriverHomeView());
    toggleLoading(false);
  }
}
