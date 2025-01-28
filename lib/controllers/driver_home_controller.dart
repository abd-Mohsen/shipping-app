import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/models/governorate_model.dart';
import 'package:shipment/models/order_model.dart';
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

  void setGovernorate(GovernorateModel? governorate) {
    selectedGovernorate = governorate;
    refreshExploreOrders();
  }

  void getGovernorates() async {
    toggleLoadingGovernorate(true);
    List<GovernorateModel> newItems = await RemoteServices.fetchGovernorates() ?? [];
    governorates.addAll(newItems);
    if (newItems.isNotEmpty) setGovernorate(governorates[3]);
    toggleLoadingGovernorate(false);
  }

  void getExploreOrders() async {
    //todo: implement pagination
    toggleLoadingExplore(true);
    List<OrderModel> newItems = await RemoteServices.fetchExploreOrders(selectedGovernorate!.id) ?? [];
    exploreOrders.addAll(newItems);
    toggleLoadingExplore(false);
  }

  Future<void> refreshExploreOrders() async {
    exploreOrders.clear();
    getExploreOrders();
  }

  void getCurrentUser() async {
    toggleLoadingUser(true);
    _currentUser = await RemoteServices.fetchCurrentUser();
    //todo: show (complete account) page to change id and license if not verified
    //todo: dont let user logout if user is loading (it may redirect after logout)
    //todo: do the same for customer and company
    /*
      'Pending', 'Verified', 'Refused', 'No_Input',
    */
    if (_currentUser != null) {
      if (!_currentUser!.isVerified) {
        Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      } else if (_currentUser!.driverInfo!.vehicleStatus == "No_Input") {
        //todo: show a dialog, you must add a vehicle before using the app
        Get.to(() => const MyVehiclesView());
      } else if (_currentUser!.driverInfo!.idStatus == "Pending" ||
          _currentUser!.driverInfo!.licenseStatus == "Pending") {
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("بياناتك لم تقبل بعد", style: TextStyle(color: Colors.black)),
            content: const Text("يرجى التواصل مع الشركة لتفعيل حسابك", style: TextStyle(color: Colors.black)),
            actions: [
              TextButton(
                onPressed: () {
                  logout();
                  //todo: go to complete account page
                },
                child: const Text(
                  "تسجيل خروج",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
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
