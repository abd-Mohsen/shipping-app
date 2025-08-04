import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shipment/views/login_view.dart';

import '../services/remote_services.dart';

class EditProfileController extends GetxController {
  @override
  void onInit() {
    user = cUC.currentUser;
    firstName.text = user!.firstName;
    lastName.text = user!.lastName;
    middleName.text = user!.middleName;
    if (user!.role.type == "company") companyName.text = user!.companyInfo!.name;
    super.onInit();
  }

  UserModel? user;
  CurrentUserController cUC = Get.find();

  //loading and editing controllers and pics
  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  bool button1Pressed = false;

  GlobalKey<FormState> passFormKey = GlobalKey<FormState>();
  bool button2Pressed = false;

  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController companyName = TextEditingController();

  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController reNewPass = TextEditingController();

  bool _oldPasswordVisible = false;
  bool get oldPasswordVisible => _oldPasswordVisible;
  void toggleOldPasswordVisibility(bool value) {
    _oldPasswordVisible = value;
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  void submitProfile() async {
    if (isLoading) return;
    button1Pressed = true;
    bool valid = profileFormKey.currentState!.validate();
    if (!valid) return;
    toggleLoading(true);
    bool success = await RemoteServices.editProfile(
        firstName: firstName.text, lastName: lastName.text, companyName: companyName.text);
    if (success) {
      if (Get.routing.current == "/EditProfileView") Get.back();
      cUC.getCurrentUser();
      Get.showSnackbar(GetSnackBar(
        message: "done successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    toggleLoading(false);
  }

  void submitPass() async {
    if (isLoading) return;
    button2Pressed = true;
    bool valid = passFormKey.currentState!.validate();
    if (!valid) return;
    toggleLoading(true);
    bool success = await RemoteServices.changePassword(oldPass.text, newPass.text, reNewPass.text);
    if (success) {
      if (Get.routing.current == "/EditProfileView") Get.back();
      cUC.getCurrentUser();
      Get.showSnackbar(GetSnackBar(
        message: "done successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    toggleLoading(false);
  }

  //------------------------ delete profile ------------------------------

  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;
  void toggleLoadingDelete(bool value) {
    _isLoadingDelete = value;
    update();
  }

  GlobalKey<FormState> deleteFormKey = GlobalKey<FormState>();
  bool button3Pressed = false;

  final GetStorage _getStorage = GetStorage();

  void deleteAccount() async {
    if (isLoadingDelete) return;
    button3Pressed = true;
    bool valid = deleteFormKey.currentState!.validate();
    if (!valid) return;
    toggleLoadingDelete(true);
    bool success = await RemoteServices.deleteAccount(oldPass.text);
    if (success) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.offAll(() => const LoginView());
      Get.showSnackbar(GetSnackBar(
        message: "done successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    toggleLoadingDelete(false);
  }
}
