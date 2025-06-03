import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/controllers/filter_controller.dart';
import 'package:shipment/controllers/home_navigation_controller.dart';
// import 'package:shipment/models/order_model.dart';
import '../models/order_model_2.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'login_controller.dart';
import 'otp_controller.dart';

class CustomerHomeController extends GetxController {
  HomeNavigationController homeNavigationController;
  FilterController filterController;
  CustomerHomeController({required this.homeNavigationController, required this.filterController});

  @override
  onInit() {
    getCurrentUser();
    getOrders();
    getRecentOrders();
    super.onInit();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchQuery = TextEditingController();

  List<OrderModel2> myOrders = [];

  List<OrderModel2> recentOrders = [];

  List<String> orderTypes = ["not taken", "taken", "current", "finished"];

  List<IconData> orderIcons = [
    Icons.done,
    Icons.watch_later,
    Icons.local_shipping,
    Icons.done_all,
  ];

  List<String> selectedOrderTypes = ["current"];
  //String selectedOrderType = "current";

  OrderModel2? currentOrder;

  void setOrderType(String? type, bool clear, {bool selectAll = false}) {
    if (type == null) return;
    if (clear) {
      selectedOrderTypes.clear();
      homeNavigationController.changeTab(0);
    }
    if (selectAll) {
      selectedOrderTypes.length == orderTypes.length
          ? selectedOrderTypes.clear()
          : selectedOrderTypes = List.from(orderTypes);
    } else {
      selectedOrderTypes.contains(type) ? selectedOrderTypes.remove(type) : selectedOrderTypes.add(type);
    }
    refreshOrders();
  }

  void getOrders() async {
    toggleLoading(true);
    List<String> typesToFetch = [];
    if (selectedOrderTypes.contains("not taken")) typesToFetch.addAll(["available", "draft"]);
    if (selectedOrderTypes.contains("taken")) typesToFetch.addAll(["pending", "approved", "waiting_approval"]);
    if (selectedOrderTypes.contains("current")) typesToFetch.addAll(["processing"]);
    if (selectedOrderTypes.contains("finished")) typesToFetch.addAll(["done", "canceled"]);
    List<OrderModel2> newItems = await RemoteServices.fetchCustomerOrders(
          types: typesToFetch,
          page: 1, //todo:pagination
          searchQuery: searchQuery.text.trim(),
          minPrice: filterController.minPrice == filterController.sliderMinPrice ? null : filterController.minPrice,
          maxPrice: filterController.maxPrice == filterController.sliderMaxPrice ? null : filterController.maxPrice,
          vehicleType: filterController.selectedVehicleType?.id,
          governorate: filterController.selectedGovernorate?.id,
          currency: filterController.selectedCurrency?.id,
        ) ??
        [];
    myOrders.addAll(newItems);
    toggleLoading(false);
  }

  Future<void> refreshOrders() async {
    myOrders.clear();
    getOrders();
  }

  Timer? _debounce;
  search() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      refreshOrders();
    });
  }

  void getRecentOrders() async {
    toggleLoadingRecent(true);
    List<String> typesToFetch = ["available", "draft", "waiting_approval", "pending", "approved", "done", "canceled"];
    List<OrderModel2> newProcessingOrders = await RemoteServices.fetchCustomerOrders(types: ["processing"]) ?? [];
    List<OrderModel2> newOrders = await RemoteServices.fetchCustomerOrders(types: typesToFetch) ?? [];
    recentOrders.addAll(newProcessingOrders);
    recentOrders.addAll(newOrders);
    if (newProcessingOrders.isNotEmpty) currentOrder = newProcessingOrders.first;
    //currentOrder = newOrders.first;
    toggleLoadingRecent(false);
  }

  Future<void> refreshRecentOrders() async {
    recentOrders.clear();
    getRecentOrders();
  }

  void deleteOrder(int id) async {
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

  bool _isLoadingRecent = false;
  bool get isLoadingRecent => _isLoadingRecent;
  void toggleLoadingRecent(bool value) {
    _isLoadingRecent = value;
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
