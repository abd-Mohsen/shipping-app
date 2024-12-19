import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constants.dart';
import '../models/user_model.dart';

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
    // toggleLoadingUser(true);
    // _currentUser = await RemoteServices.fetchCurrentUser();
    // if (_currentUser != null && !_currentUser!.isActivated) {
    //   Get.dialog(kActivateAccountDialog(), barrierDismissible: false);
    // } else if (_currentUser != null && !_currentUser!.isVerified) {
    //   Get.to(() => const OTPView(source: "register"));
    // }
    // toggleLoadingUser(false);
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
    // if (await RemoteServices.logout()) {
    //   _getStorage.remove("token");
    //   _getStorage.remove("role");
    //   Get.put(LoginController());
    //   Get.offAll(() => const LoginView());
    // }
  }
}
