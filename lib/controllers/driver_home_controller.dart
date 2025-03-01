import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/models/governorate_model.dart';
import 'package:shipment/models/order_model.dart';
import 'package:shipment/views/complete_account_view.dart';
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
    getGovernorates();
    getCurrentOrders();
    getHistoryOrders();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isLoadingExplore = false;
  bool get isLoadingExplore => _isLoadingExplore;
  void toggleLoadingExplore(bool value) {
    _isLoadingExplore = value;
    update();
  }

  bool _isLoadingCurrent = false;
  bool get isLoadingCurrent => _isLoadingCurrent;
  void toggleLoadingCurrent(bool value) {
    _isLoadingCurrent = value;
    update();
  }

  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;
  void toggleLoadingHistory(bool value) {
    _isLoadingHistory = value;
    update();
  }

  bool _isLoadingGovernorates = false;
  bool get isLoadingGovernorates => _isLoadingGovernorates;
  void toggleLoadingGovernorate(bool value) {
    _isLoadingGovernorates = value;
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

  List<GovernorateModel> governorates = [];
  GovernorateModel? selectedGovernorate;

  List<OrderModel> exploreOrders = [];
  List<OrderModel> currOrders = [];
  List<OrderModel> historyOrders = [];

  void setGovernorate(GovernorateModel? governorate) {
    selectedGovernorate = governorate;
    refreshExploreOrders();
  }

  void getGovernorates() async {
    toggleLoadingGovernorate(true);
    List<GovernorateModel> newItems = await RemoteServices.fetchGovernorates() ?? [];
    governorates.addAll(newItems);
    if (newItems.isNotEmpty) setGovernorate(governorates[1]);
    toggleLoadingGovernorate(false);
  }

  void getExploreOrders() async {
    //todo: implement pagination
    if (selectedGovernorate == null) return;
    toggleLoadingExplore(true);
    List<OrderModel> newItems = await RemoteServices.fetchDriverOrders(selectedGovernorate!.id, ["available"]) ?? [];
    exploreOrders.addAll(newItems);
    toggleLoadingExplore(false);
  }

  void getCurrentOrders() async {
    //todo: implement pagination
    toggleLoadingCurrent(true);
    List<OrderModel> newItems = await RemoteServices.fetchDriverOrders(null, ["processing", "pending"]) ?? [];
    currOrders.addAll(newItems);
    toggleLoadingCurrent(false);
    print(currOrders.length);
  }

  void getHistoryOrders() async {
    //todo: implement pagination
    toggleLoadingHistory(true);
    List<OrderModel> newItems = await RemoteServices.fetchDriverOrders(null, ["done"]) ?? [];
    historyOrders.addAll(newItems);
    toggleLoadingHistory(false);
  }

  Future<void> refreshExploreOrders() async {
    exploreOrders.clear();
    getExploreOrders();
  }

  Future<void> refreshCurrOrders() async {
    currOrders.clear();
    getCurrentOrders();
  }

  Future<void> refreshHistoryOrders() async {
    historyOrders.clear();
    getHistoryOrders();
  }

  void getCurrentUser() async {
    toggleLoadingUser(true);
    _currentUser = await RemoteServices.fetchCurrentUser();
    //todo: dont let user do anything before user is loaded
    //todo: show (complete account) page to change id and license if not verified
    //todo: dont let user logout if user is loading (it may redirect after logout)
    //todo: do the same for customer and company
    /*
      'Pending', 'Verified', 'Refused', 'No_Input',
    */
    if (_currentUser != null) {
      if (_currentUser!.driverInfo!.vehicleStatus == "No_Input") {
        //todo: handle the cars case
        Get.to(() => const MyVehiclesView());
      }
      if (_currentUser!.driverInfo!.idStatus.toLowerCase() != "verified" ||
          _currentUser!.driverInfo!.licenseStatus.toLowerCase() != "verified") {
        Get.to(CompleteAccountView(user: _currentUser!));
      }
      if (!_currentUser!.isVerified) {
        Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      }
    }

    toggleLoadingUser(false);
  }

  // Position? position;
  //
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
    //todo: add loading to prevent spam
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }
}
