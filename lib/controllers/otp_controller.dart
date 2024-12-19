import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shipment/controllers/reset_password_controller.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:flutter/material.dart';

import '../services/remote_services.dart';
import 'login_controller.dart';

class OTPController extends GetxController {
  ResetPassController? resetController;
  OTPController(this.resetController);
  final OtpFieldController otpController = OtpFieldController();
  final CountdownController timeController = CountdownController(autoStart: true);

  final GetStorage _getStorage = GetStorage();

  @override
  void onInit() async {
    //todo(later): handle null, and the otp page might open while not receiving the code (timeout)
    //todo(later): sometimes i get a timeout, but receive the code anyways
    //_verifyUrl = (await RemoteServices.sendRegisterOtp())!;
    super.onInit();
  }

  bool _isTimeUp = false;
  bool get isTimeUp => _isTimeUp;
  void toggleTimerState(bool val) {
    _isTimeUp = val;
    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  late String _verifyUrl;

  void resendOtp() async {
    if (!_isTimeUp || isLoading) return;
    toggleLoading(true);

    if (resetController == null) {
      // String? res = await RemoteServices.sendRegisterOtp();
      // if (res == null) {
      //   toggleLoading(false);
      //   return;
      // }
     // _verifyUrl = res;
    } else {
     // await RemoteServices.sendForgotPasswordOtp(resetController!.email.text);
    }
    timeController.restart();
    otpController.clear();
    _isTimeUp = false;

    toggleLoading(false);
  }

  void verifyOtp(String pin) async {
    if (_isTimeUp) {
      Get.showSnackbar(const GetSnackBar(
        message: "انتهت صلاحية الرمز, اطلب رمزأً جديدا",
        duration: Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      return;
    }
    toggleLoading(true);

    if (resetController == null) {
      if (await RemoteServices.verifyRegisterOtp(_verifyUrl, pin)) {
        Get.back();
        Get.showSnackbar(const GetSnackBar(
          message: "تم التأكيد بنجاح",
          duration: Duration(milliseconds: 2500),
          backgroundColor: Colors.green,
        ));
      } else {
        otpController.clear();
      }
    } else {
      String? resetToken = await RemoteServices.verifyForgotPasswordOtp(resetController!.email.text, pin);
      if (resetToken == null) {
        otpController.clear();
      } else {
        resetController!.setResetToken(resetToken);
       // Get.off(() => const ResetPasswordView2());
      }
    }
    toggleLoading(false);
  }

  void logout() async {
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      //Get.offAll(() => const LoginView());
    }
  }
}
