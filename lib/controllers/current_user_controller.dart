import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/views/my_vehicles_view.dart';

import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/complete_account_view.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'complete_account_controller.dart';
import 'login_controller.dart';
import 'otp_controller.dart';

class CurrentUserController extends GetxController {
  UserModel? currentUser;

  @override
  void onInit() {
    getCurrentUser();
    super.onInit();
  }

  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;
  void toggleLoadingUser(bool value) {
    _isLoadingUser = value;
    update();
  }

  final GetStorage _getStorage = GetStorage();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getCurrentUser({bool refresh = false}) async {
    //if (isLoadingUser) return;
    toggleLoadingUser(true);
    currentUser = await RemoteServices.fetchCurrentUser();
    /*
      'Pending', 'Verified', 'Refused', 'No_Input',
    */
    if (!refresh && currentUser != null) {
      if (["driver", "company_employee"].contains(currentUser!.role.type) &&
          currentUser!.driverInfo!.licenseStatus.toLowerCase() != "verified") {
        Get.put(CompleteAccountController(homeController: this));
        Get.to(const CompleteAccountView());
      }
      if (!currentUser!.isVerified) {
        Get.put(OTPController(currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      }

      bool noValidCar = currentUser!.role.type == "driver" &&
          ["refused", "No_Input"].contains(currentUser!.driverInfo?.vehicleStatus);

      if (noValidCar) {
        Get.dialog(kNoValidCarDialog(() => Get.off(() => const MyVehiclesView())), barrierDismissible: false);
      }
    }

    if (currentUser == null) {
      //todo(later): put first to get correct loading (in all roles)
      await Future.delayed(const Duration(seconds: 10));
      getCurrentUser();
    }

    toggleLoadingUser(false);
  }

  bool isLoadingLogout = false;
  void toggleLoadingLogout(bool value) {
    isLoadingLogout = value;
    update();
  }

  void logout() async {
    if (isLoadingLogout) return;
    toggleLoadingLogout(true);
    if (currentUser != null && await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
    toggleLoadingLogout(false);
  }
}
