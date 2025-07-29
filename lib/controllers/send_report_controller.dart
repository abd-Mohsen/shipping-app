import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../services/remote_services.dart';

class SendReportController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  final subject = TextEditingController();
  final message = TextEditingController();

  void sendReport() async {
    if (isLoading) return;
    buttonPressed = true;
    bool isValid = formKey.currentState!.validate();
    if (!isValid) return;
    toggleLoading(true);
    bool success = await RemoteServices.sendReport(subject.text, message.text);
    if (success) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "report was sent to technical support".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    toggleLoading(false);
  }
}
