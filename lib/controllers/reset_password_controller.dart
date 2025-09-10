import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shipment/controllers/otp_controller.dart';

import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';

class ResetPassController extends GetxController {
  final phone = TextEditingController();
  final newPassword = TextEditingController();
  final rePassword = TextEditingController();

  String? _resetToken;
  String? get resetToken => _resetToken;
  void setResetToken(String val) {
    _resetToken = val;
  }

  bool _isLoading1 = false;
  bool get isLoading1 => _isLoading1;
  void toggleLoading1(bool value) {
    _isLoading1 = value;
    update();
  }

  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  bool button1Pressed = false;

  Future toOTP() async {
    if(isLoading1) return;
    button1Pressed = true;
    bool isValid = firstFormKey.currentState!.validate();
    if (!isValid) return;
    toggleLoading1(true);

    if (await RemoteServices.sendOtp(phone.text)) {
      Get.put(OTPController(phone.text, "reset", this));
      Get.to(() => const OTPView(source: "reset"));
    }

    toggleLoading1(false);
  }

  //--------------------------------------------------------------------------------
  //for second screen

  GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
  bool button2Pressed = false;

  late String otp;

  void setOtp(String otp) {
    this.otp = otp;
  }

  bool _isLoading2 = false;
  bool get isLoading2 => _isLoading2;
  void toggleLoading2(bool value) {
    _isLoading2 = value;
    update();
  }

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility(bool value) {
    _passwordVisible = value;
    update();
  }

  bool _rePasswordVisible = false;
  bool get rePasswordVisible => _rePasswordVisible;
  void toggleRePasswordVisibility(bool value) {
    _rePasswordVisible = value;
    update();
  }

  void resetPass() async {
    button2Pressed = true;
    bool isValid = secondFormKey.currentState!.validate();
    if (!isValid) return;
    toggleLoading2(true);

    if (await RemoteServices.resetPassword(resetToken!, newPassword.text, rePassword.text)) {
      Get.offAll(() => const LoginView());
      Get.showSnackbar(GetSnackBar(
        message: "done successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }

    toggleLoading2(false);
  }
}
