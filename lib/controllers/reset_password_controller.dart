import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

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
    button1Pressed = true;
    bool isValid = firstFormKey.currentState!.validate();
    if (!isValid) return;
    toggleLoading1(true);

    // if (await RemoteServices.sendForgotPasswordOtp(email.text).timeout(kTimeOutDuration)) {
    //   Get.to(() => const OTPView(source: "reset"));
    // }

    toggleLoading1(false);
  }

  //--------------------------------------------------------------------------------
  //for second screen

  GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
  bool button2Pressed = false;

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

    // if (await RemoteServices.resetPassword(email.text, newPassword.text, _resetToken!)) {
    //   Get.offAll(() => const LoginView());
    //   Get.showSnackbar(const GetSnackBar(
    //     message: "تم بنجاح",
    //     duration: Duration(milliseconds: 2500),
    //     backgroundColor: Colors.green,
    //   ));
    // }

    toggleLoading2(false);
  }
}
