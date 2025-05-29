import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/compress_image_service.dart';
import '../services/remote_services.dart';

class RegisterController extends GetxController {
  @override
  void onClose() {
    //
    super.onClose();
  }

  List<String> roles = [
    "driver",
    "customer",
    "company",
    "employee",
  ];

  int roleIndex = 0;

  void setRole(int newIndex) {
    roleIndex = newIndex;
    update();
  }

  @override
  void onInit() {
    //getSupervisorsNames();
    super.onInit();
  }

  final companyName = TextEditingController();
  final otp = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final phone = TextEditingController();

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

  XFile? idFront;
  XFile? idRear;
  XFile? dLicenseFront;
  XFile? dLicenseRear;

  Future pickImage(String selectedImage, String source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedImage == null) return;

    pickedImage = await CompressImageService().compressImage(pickedImage);

    if (selectedImage == "ID (front)".tr) idFront = pickedImage;
    if (selectedImage == "ID (rear)".tr) idRear = pickedImage;
    if (selectedImage == "driving license (front)".tr) dLicenseFront = pickedImage;
    if (selectedImage == "driving license (rear)".tr) dLicenseRear = pickedImage;

    update();
    Get.back();
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
    //todo: make ID optional, here and in complete account
    //todo: add map selector here
    if (((roles[roleIndex] == "employee" || roles[roleIndex] == "driver") &&
        (dLicenseFront == null || dLicenseRear == null))) {
      Get.showSnackbar(GetSnackBar(
        message: "select all required images first".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      return;
    }
    toggleLoadingRegister(true);
    File? idFrontFile = idFront == null ? null : File(idFront!.path);
    File? idRearFile = idRear == null ? null : File(idRear!.path);
    File? lFrontFile = dLicenseFront == null ? null : File(dLicenseFront!.path);
    File? lRearFile = dLicenseRear == null ? null : File(dLicenseRear!.path);

    bool success = (await RemoteServices.register(
      userName.text,
      firstName.text,
      lastName.text,
      roles[roleIndex] == "employee" ? "company_employee" : roles[roleIndex],
      phone.text,
      password.text,
      rePassword.text,
      roles[roleIndex] == "company" ? companyName.text : null,
      roles[roleIndex] == "employee" ? otp.text : null,
      ["driver", "employee", "company"].contains(roles[roleIndex]) ? idFrontFile : null,
      ["driver", "employee", "company"].contains(roles[roleIndex]) ? idRearFile : null,
      ["driver", "employee"].contains(roles[roleIndex]) ? lFrontFile : null,
      ["driver", "employee"].contains(roles[roleIndex]) ? lRearFile : null,
    ));
    if (success) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "done successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    toggleLoadingRegister(false);
  }
}
