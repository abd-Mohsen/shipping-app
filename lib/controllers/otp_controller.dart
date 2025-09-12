import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shipment/controllers/reset_password_controller.dart';
import 'package:shipment/views/register_view.dart';
import 'package:shipment/views/reset_pass_view2.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:flutter/material.dart';
import '../services/remote_services.dart';

class OTPController extends GetxController {
  late String phone;
  late String source;
  ResetPassController? resetPassController;

  OTPController(this.phone, this.source, this.resetPassController);

  final OtpFieldController otpFieldController = OtpFieldController();
  final CountdownController timeController = CountdownController(autoStart: true);

  //final GetStorage _getStorage = GetStorage();

  @override
  void onInit() async {
    //handle null, and the otp page might open while not receiving the code (timeout)
    //sometimes i get a timeout, but receive the code anyways
    //if (!_getStorage.hasData("from_register")) await RemoteServices.sendOtp(phone, false);
    await Future.delayed(const Duration(milliseconds: 200));
    otpFieldController.setFocus(0);
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

  //late String _verifyUrl;

  void resendOtp() async {
    if (!_isTimeUp || isLoading) return;
    toggleLoading(true);
    bool sent = await RemoteServices.sendOtp(phone,source == "register");
    if (sent) {
      timeController.restart();
      otpFieldController.clear();
      otpFieldController.setFocus(0);
      _isTimeUp = false;
    }
    toggleLoading(false);
  }

  void verifyOtp(String pin) async {
    if (_isTimeUp) {
      Get.showSnackbar(GetSnackBar(
        message: "the code is expired, request new one".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      return;
    }
    toggleLoading(true);
    String? resetToken = await RemoteServices.verifyOtp(phone, pin); //success
    if (resetToken != null) {
      if (source == "register") {
        // Get.back();
        // Get.showSnackbar(GetSnackBar(
        //   message: "done successfully".tr,
        //   duration: const Duration(milliseconds: 2500),
        //   backgroundColor: Colors.green,
        // ));
        Get.off(() => RegisterView() );
      } else {
        resetPassController!.setOtp(pin);
        resetPassController!.setResetToken(resetToken);
        Get.off(() => const ResetPassView2());
      }
    } else {
      Get.showSnackbar(GetSnackBar(
        message: "incorrect".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      otpFieldController.clear();
    }
    toggleLoading(false);
  }

  // logout from current user controller instead
  // void logout() async {
  //   if (await RemoteServices.logout()) {
  //     _getStorage.remove("token");
  //     _getStorage.remove("role");
  //     Get.put(LoginController());
  //     Get.offAll(() => const LoginView());
  //   }
  // }
}
