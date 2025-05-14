import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/models/order_model.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<OrderModel> myOrders = [];

  List<String> orderTypes = ["not taken", "taken", "current", "finished"];

  String selectedOrderType = "current";

  void setOrderType(String? type) {
    if (type == null) return;
    selectedOrderType = type;
    refreshOrders();
  }

  void getOrders() async {
    //todo:pagination
    toggleLoading(true);
    List<String> typesToFetch = [];
    if (selectedOrderType == "not taken") typesToFetch = ["available", "draft"];
    if (selectedOrderType == "taken") typesToFetch = ["pending", "approved"];
    if (selectedOrderType == "current") typesToFetch = ["processing"];
    if (selectedOrderType == "finished") typesToFetch = ["done", "canceled"];
    List<OrderModel> newItems = await RemoteServices.fetchCustomerOrders(typesToFetch) ?? [];
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

  void getCurrentUser({bool refresh = false}) async {
    toggleLoadingUser(true);
    _currentUser = await RemoteServices.fetchCurrentUser();
    if (!refresh && _currentUser != null) {
      if (!_currentUser!.isVerified) {
        Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      }
    }
    if (currentUser == null) {
      await Future.delayed(Duration(seconds: 10));
      getCurrentUser();
    }
    toggleLoadingUser(false);
  }

  Position? position;

  void logout() async {
    if (currentUser != null && await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }
}
