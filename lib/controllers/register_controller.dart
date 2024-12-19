import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/user_model.dart';

class RegisterController extends GetxController {
  @override
  void onClose() {
    // email.dispose();
    // password.dispose();
    // rePassword.dispose();
    // fName.dispose();
    // lName.dispose();
    // phone.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    getSupervisorsNames();
    super.onInit();
  }

  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final phone = TextEditingController();
  String roleINEnglish = "supervisor";
  String selectedRole = "مشرف";
  UserModel? selectedSupervisor; //(show if role is 3)

  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  bool _isLoadingRegister = false;
  bool get isLoading => _isLoadingRegister;
  void toggleLoadingRegister(bool value) {
    _isLoadingRegister = value;
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

  void setRole(String role) {
    role == "مشرف" ? roleINEnglish = "supervisor" : roleINEnglish = "salesman";
    selectedRole = role;
    update();
  }

  void setSupervisor(UserModel supervisor) {
    selectedSupervisor = supervisor;
    update();
  }

  List<UserModel> availableSupervisors = [];
  Future<void> getSupervisorsNames() async {
    // List<UserModel> supervisors = await RemoteServices.fetchSupervisors() ?? [];
    // for (UserModel supervisor in supervisors) {
    //   availableSupervisors.add(supervisor);
    // }
    update();
  }

  Future register() async {
    buttonPressed = true;
    bool isValid = registerFormKey.currentState!.validate();
    if (!isValid) return;
    toggleLoadingRegister(true);

    // bool success = (await RemoteServices.register(
    //   userName.text,
    //   email.text,
    //   password.text,
    //   rePassword.text,
    //   phone.text,
    //   roleINEnglish,
    //   roleINEnglish == "salesman" ? selectedSupervisor?.id : null,
    // ));
    if (true /*success*/) {
      Get.back();
      Get.defaultDialog(
        titleStyle: const TextStyle(color: Colors.black),
        middleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        title: "تم التسجيل",
        middleText: "الرجاء انتظار موافقة المسؤول في الشركة",
        // confirm: TextButton(
        //   onPressed: () {
        //     Get.back();
        //   },
        //   child: Text("ok"),
        // )
      );
    }

    toggleLoadingRegister(false);
  }
  //--------------------------------------------------------------------------------
  //for otp

  // final OtpFieldController otpController = OtpFieldController();
  // final CountdownController timeController = CountdownController(autoStart: true);
  //
  // late String _registerToken;
  // bool _isTimeUp = false;
  // bool get isTimeUp => _isTimeUp;
  // late String _verifyUrl;
  //
  // bool _isLoadingOtp = false;
  // bool get isLoadingOtp => _isLoadingOtp;
  //
  // void toggleLoadingOtp(bool value) {
  //   _isLoadingOtp = value;
  //   update();
  // }
  //
  // void toggleTimerState(bool val) {
  //   _isTimeUp = val;
  //   update();
  // }
  //
  // void verifyOtp(String pin) async {
  //   if (_isTimeUp) {
  //     Get.defaultDialog(middleText: "otp time up dialog".tr);
  //   } else {
  //     toggleLoadingOtp(true);
  //     try {
  //       if (await RemoteServices.verifyRegisterOtp(_verifyUrl, _registerToken, pin).timeout(kTimeOutDuration)) {
  //         Get.offAll(() => const LoginPage());
  //         Get.defaultDialog(middleText: "account created successfully, please login".tr);
  //       } else {
  //         Get.defaultDialog(middleText: "wrong otp dialog".tr);
  //       }
  //     } on TimeoutException {
  //       kTimeOutDialog();
  //     } catch (e) {
  //       //print(e.toString());
  //     } finally {
  //       toggleLoadingOtp(false);
  //     }
  //   }
  // }
  //
  // void resendOtp() async {
  //   if (_isTimeUp) {
  //     toggleLoadingOtp(true);
  //     try {
  //       _verifyUrl = (await RemoteServices.sendRegisterOtp(_registerToken).timeout(kTimeOutDuration))!;
  //       timeController.restart();
  //       otpController.clear();
  //       _isTimeUp = false;
  //     } on TimeoutException {
  //       kTimeOutDialog();
  //     } catch (e) {
  //       //print(e.toString());
  //     } finally {
  //       toggleLoadingOtp(false);
  //     }
  //   } else {
  //     Get.showSnackbar(GetSnackBar(
  //       messageText: Text(
  //         "wait till time is up".tr,
  //         textAlign: TextAlign.center,
  //         style: kTextStyle14.copyWith(color: Colors.white),
  //       ),
  //       backgroundColor: Colors.grey.shade800,
  //       duration: const Duration(milliseconds: 800),
  //       borderRadius: 30,
  //       maxWidth: 150,
  //       margin: const EdgeInsets.only(bottom: 50),
  //     ));
  //   }
  // }
}
