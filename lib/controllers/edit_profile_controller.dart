import 'package:get/get.dart';
import 'package:shipment/models/user_model.dart';
import 'package:flutter/material.dart';

import '../services/remote_services.dart';

class EditProfileController extends GetxController {
  //todo implement for all roles
  //todo add delete profile
  //todo add change password

  @override
  void onInit() {
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    if (user.role.type == "company") companyName.text = user.companyInfo!.name;
    super.onInit();
  }

  UserModel user;
  dynamic homeController;
  EditProfileController({required this.user, required this.homeController});

  //loading and editing controllers and pics
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController companyName = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  void submit() async {
    if (isLoading) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    toggleLoading(true);
    bool success = await RemoteServices.editProfile(
        firstName: firstName.text, lastName: lastName.text, companyName: companyName.text);
    if (success) {
      Get.back();
      homeController.getCurrentUser();
      Get.showSnackbar(GetSnackBar(
        message: "profile updated successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    toggleLoading(false);
  }
}
