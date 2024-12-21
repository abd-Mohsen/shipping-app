import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../models/user_model.dart';

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
    //"employee",
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
  final numberOfVehicles = TextEditingController();
  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
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

  Future pickImage(XFile? selectedImage, String source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
    );
    if (selectedImage == idFront) idFront = pickedImage; //todo: all of them are updating at once
    if (selectedImage == idRear) idRear = pickedImage;
    //if (selectedImage == dLicenseFront) dLicenseFront = pickedImage;
    if (selectedImage == dLicenseRear) dLicenseRear = pickedImage;
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
    // todo: check if the required photos are not null (based on role)
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
}
