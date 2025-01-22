import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/views/my_vehicles_view.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'login_controller.dart';
import 'otp_controller.dart';

class DriverHomeController extends GetxController {
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
    //todo: show (complete account) page to change id and license if not verified
    if (_currentUser != null) {
      if (!_currentUser!.isVerified) {
        Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      } else if (!_currentUser!.driverInfo!.hasAVehicle) {
        //todo: show a dialog, you must add a vehicle before using the app
        Get.to(() => const MyVehiclesView());
      } else if (!_currentUser!.driverInfo!.isVerifiedId || !_currentUser!.driverInfo!.isVerifiedLicense) {
        Get.dialog(
            AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("بياناتك لم تقبل بعد", style: TextStyle(color: Colors.black)),
              content: const Text("يرجى التواصل مع الشركة لتفعيل حسابك", style: TextStyle(color: Colors.black)),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.offAll(() => const LoginView()); //todo: go to complete account page
                  },
                  child: const Text(
                    "تسجيل خروج",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            barrierDismissible: false);
      }
    }

    toggleLoadingUser(false);
  }

  Position? position;

  Future<void> getLocation(context) async {
    ColorScheme cs = Theme.of(context).colorScheme;
    toggleLoading(true);
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      toggleLoading(false);
      Get.defaultDialog(
        title: "",
        content: Column(
          children: [
            const Icon(
              Icons.location_on,
              size: 80,
            ),
            Text(
              "من فضلك قم بتشغيل خدمة تحديد الموقع أولاً",
              style: TextStyle(fontSize: 24, color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toggleLoading(false);
        Get.showSnackbar(const GetSnackBar(
          message: "تم رفض صلاحية الموقع, لا يمكن تحديد موقعك الحالي",
          duration: Duration(milliseconds: 1500),
        ));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      toggleLoading(false);
      Get.showSnackbar(const GetSnackBar(
        message: "تم رفض صلاحية الموقع, يجب اعطاء صلاحية من اعدادات التطبيق",
        duration: Duration(milliseconds: 1500),
      ));
    }
    try {
      position = await Geolocator.getCurrentPosition().timeout(kTimeOutDuration);
    } on TimeoutException {
      Get.showSnackbar(kTimeOutSnackBar());
      toggleLoading(false);
    } catch (e) {
      print(e.toString());
    }
    print('${position!.longitude} ${position!.latitude}');
    toggleLoading(false);
  }

  void logout() async {
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }
}
