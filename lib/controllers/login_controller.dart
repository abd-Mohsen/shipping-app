import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/views/company_home_view.dart';
import 'package:shipment/views/customer_home_view.dart';
import 'package:shipment/views/driver_home_view.dart';
import 'package:shipment/views/redirect_page.dart';

import '../models/login_model.dart';
import '../services/remote_services.dart';

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
    //todo(later): login controller is not disposed after logging in
    if (isLoading) return; // todo (later): do this for every button, to not send multiple requests
    buttonPressed = true;
    bool isValid = loginFormKey.currentState!.validate();
    if (!isValid) return;
    toggleLoading(true);
    LoginModel? loginData = await RemoteServices.login(phone.text, password.text);
    if (loginData == null) {
      toggleLoading(false);
      return;
    }
    _getStorage.write("token", loginData.token);
    _getStorage.write("role", loginData.role.type);
    _getStorage.write("id", loginData.id);
    print(_getStorage.read("token"));
    if (loginData.role.type == "driver" || loginData.role.type == "company_employee") {
      Get.offAll(() => const DriverHomeView(), binding: DriverBindings());
    } else if (loginData.role.type == "customer") {
      Get.offAll(() => const CustomerHomeView(), binding: CustomerBindings());
    } else if (loginData.role.type == "company") {
      Get.offAll(() => const CompanyHomeView(), binding: CompanyBindings());
    } else {
      print("wrong role");
      return; // other role
    }
    toggleLoading(false);
  }
}
