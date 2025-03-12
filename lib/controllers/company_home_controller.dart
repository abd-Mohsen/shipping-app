import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'login_controller.dart';
import 'package:flutter/material.dart';

import 'otp_controller.dart';

class CompanyHomeController extends GetxController {
  @override
  onInit() {
    getCurrentUser();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;
  void toggleLoadingUser(bool value) {
    _isLoadingUser = value;
    update();
  }

  bool _isLoadingSubmit = false;
  bool get isLoadingSubmit => _isLoadingSubmit;
  void toggleLoadingSubmit(bool value) {
    _isLoadingSubmit = value;
    update();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void getCurrentUser() async {
    toggleLoadingUser(true);
    _currentUser = await RemoteServices.fetchCurrentUser();
    // if (_currentUser!.driverInfo != null && !_currentUser!.driverInfo!.isVerifiedId) {
    //   Get.dialog(kActivateAccountDialog(), barrierDismissible: false);
    // }
    //todo: handle the case of: no car, no license and no verified phone
    if (!_currentUser!.isVerified) {
      Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
      Get.to(() => const OTPView(source: "register"));
    }
    toggleLoadingUser(false);
  }

  void logout() async {
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }

  // -----------------employees-----------------------

  bool _isLoadingEmployees = false;
  bool get isLoadingEmployees => _isLoadingEmployees;
  void toggleLoadingEmployees(bool value) {
    _isLoadingEmployees = value;
    update();
  }

  bool _isLoadingEmployeesAdd = false;
  bool get isLoadingEmployeesAdd => _isLoadingEmployeesAdd;
  void toggleLoadingEmployeesAdd(bool value) {
    _isLoadingEmployeesAdd = value;
    update();
  }

  GlobalKey<FormState> addEmployeeFormKey = GlobalKey<FormState>();
  bool employeeButtonPressed = false;

  TextEditingController phone = TextEditingController();

  void addEmployee() async {
    if (isLoadingEmployeesAdd) return;
    bool valid = addEmployeeFormKey.currentState!.validate();
    if (!valid) return;
    employeeButtonPressed = true;
    toggleLoadingEmployeesAdd(true);
    bool success = await RemoteServices.addEmployee(phone.text);
    if (success) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "an invitation code was send to the employee".tr,
        duration: const Duration(milliseconds: 4500),
      ));
      phone.text == "";
    }
    toggleLoadingEmployeesAdd(false);
  }

  //------------------vehicles-----------------------
}
