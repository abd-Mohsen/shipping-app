import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/models/order_model.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/complete_account_view.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'login_controller.dart';
import 'otp_controller.dart';

class CustomerHomeController extends GetxController {
  @override
  onInit() {
    getCurrentUser();
    getOrders();
    super.onInit();
  }

  List<OrderModel> myOrders = [];

  void getOrders() async {
    //todo:pagination
    toggleLoading(true);
    List<OrderModel> newItems = await RemoteServices.fetchCustomerOrders() ?? [];
    myOrders.addAll(newItems);
    toggleLoading(false);
  }

  Future<void> refreshOrders() async {
    myOrders.clear();
    getOrders();
  }

  void deleteOrder(int id) async {
    //todo: orders might get duplicated after deletion, see why
    bool success = await RemoteServices.deleteCustomerOrder(id);
    if (success) {
      Get.back();
      refreshOrders();
    }
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
    if (_currentUser != null) {
      //todo: no id info in customer
      // if (_currentUser!.driverInfo!.idStatus.toLowerCase() != "verified" ||
      //     _currentUser!.driverInfo!.licenseStatus.toLowerCase() != "verified") {
      //   Get.to(CompleteAccountView(user: _currentUser!));
      // }
      if (!_currentUser!.isVerified) {
        Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      }
    }
    toggleLoadingUser(false);
  }

  Position? position;

  // Future<void> getLocation(context) async {
  //   ColorScheme cs = Theme.of(context).colorScheme;
  //   toggleLoading(true);
  //   LocationPermission permission;
  //
  //   if (!await Geolocator.isLocationServiceEnabled()) {
  //     toggleLoading(false);
  //     Get.defaultDialog(
  //       title: "",
  //       content: Column(
  //         children: [
  //           const Icon(
  //             Icons.location_on,
  //             size: 80,
  //           ),
  //           Text(
  //             "من فضلك قم بتشغيل خدمة تحديد الموقع أولاً",
  //             style: TextStyle(fontSize: 24, color: cs.onSurface),
  //             textAlign: TextAlign.center,
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       toggleLoading(false);
  //       Get.showSnackbar(const GetSnackBar(
  //         message: "تم رفض صلاحية الموقع, لا يمكن تحديد موقعك الحالي",
  //         duration: Duration(milliseconds: 1500),
  //       ));
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     toggleLoading(false);
  //     Get.showSnackbar(const GetSnackBar(
  //       message: "تم رفض صلاحية الموقع, يجب اعطاء صلاحية من اعدادات التطبيق",
  //       duration: Duration(milliseconds: 1500),
  //     ));
  //   }
  //   try {
  //     position = await Geolocator.getCurrentPosition().timeout(kTimeOutDuration);
  //   } on TimeoutException {
  //     Get.showSnackbar(kTimeOutSnackBar());
  //     toggleLoading(false);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   print('${position!.longitude} ${position!.latitude}');
  //   toggleLoading(false);
  // }

  void logout() async {
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }
}
