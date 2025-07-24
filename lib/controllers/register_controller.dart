import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/models/login_model.dart';
import 'package:shipment/views/redirect_page.dart';
import '../models/user_model.dart';
import '../services/compress_image_service.dart';
import '../services/remote_services.dart';
import '../views/company_home_view.dart';
import '../views/components/show_video_dialog.dart';
import '../views/customer_home_view.dart';
import '../views/driver_home_view.dart';

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
  void onInit() async {
    if (!_getStorage.hasData("viewed_register_dialog")) {
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.dialog(const AssetVideoDialog());
    }
    _getStorage.write("viewed_register_dialog", true);
    super.onInit();
  }

  final companyName = TextEditingController();
  final otp = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final middleName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final phone = TextEditingController();

  final GetStorage _getStorage = GetStorage();

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
    //todo(later): add map selector here
    //todo: middle name instead of username
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

    LoginModel? registerData = (await RemoteServices.register(
      firstName.text,
      middleName.text,
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
    if (registerData != null) {
      Get.back();
      _getStorage.write("token", registerData.token);
      _getStorage.write("role", registerData.role.type);
      _getStorage.write("from_register", true);
      print(_getStorage.read("token"));
      if (registerData.role.type == "driver" || registerData.role.type == "company_employee") {
        Get.offAll(() => const DriverHomeView(), binding: DriverBindings());
      } else if (registerData.role.type == "customer") {
        Get.offAll(() => const CustomerHomeView(), binding: CustomerBindings());
      } else if (registerData.role.type == "company") {
        Get.offAll(() => const CompanyHomeView(), binding: CompanyBindings());
      } else {
        print("wrong role");
        return; // other role
      }
    }

    toggleLoadingRegister(false);
  }
}
