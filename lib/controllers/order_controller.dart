import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/models/mini_order_model.dart';
import 'package:shipment/models/order_model.dart';
import 'package:flutter/material.dart';
import '../services/remote_services.dart';

class OrderController extends GetxController {
  final OrderModel order;
  final DriverHomeController? driverHomeController; // handle company and customer case
  final CustomerHomeController? customerHomeController;
  OrderController({required this.order, this.driverHomeController, this.customerHomeController});

  @override
  void onInit() {
    setStatusIndex();
    selectedPayment = order.paymentMethods[0];
    super.onInit();
  }

  GetStorage _getStorage = GetStorage();

  MapController mapController = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  int statusIndex = 0;

  void setStatusIndex() {
    if (order.status == "draft") return;
    statusIndex = statuses.indexOf(order.status);
  }

  List<String> statuses = ["available", "pending", "approved", "processing", "done"];

  late PaymentMethod selectedPayment;

  void selectPayment(PaymentMethod payment) {
    selectedPayment = payment;
    update();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  TextEditingController fullName = TextEditingController();
  TextEditingController accountDetails = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  bool _isLoadingSubmit = false;
  bool get isLoadingSubmit => _isLoadingSubmit;
  void toggleLoadingSubmit(bool value) {
    _isLoadingSubmit = value;
    update();
  }

  bool _isLoadingRefuse = false;
  bool get isLoadingRefuse => _isLoadingRefuse;
  void toggleLoadingRefuse(bool value) {
    _isLoadingRefuse = value;
    update();
  }

  bool _isLoadingCurr = false;
  bool get isLoadingCurr => _isLoadingCurr;
  void toggleLoadingCurr(bool value) {
    _isLoadingCurr = value;
    update();
  }

  List<MiniOrderModel> currOrders = [];

  void getCurrOrders() async {
    toggleLoadingCurr(true);
    currOrders.clear();
    List<MiniOrderModel> newItems = await RemoteServices.fetchDriverCurrOrders() ?? [];
    currOrders.addAll(newItems);
    toggleLoadingCurr(false);
  }

  /*
  bank account -> full name + account details
  money transfer -> full name + phone num
  */

  void acceptOrderDriver() async {
    if (isLoadingSubmit) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.driverAcceptOrder(order.id);
    if (success) {
      Get.back();
      driverHomeController!.refreshExploreOrders();
      Get.showSnackbar(GetSnackBar(
        message: "request was submitted, waiting for response".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void confirmOrderCustomer() async {
    if (isLoadingSubmit) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.customerAcceptOrder(order.id);
    if (success) {
      Get.back();
      customerHomeController!.refreshOrders();
      Get.showSnackbar(GetSnackBar(
        message: "request was submitted, waiting for response".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void confirmOrderDriver() async {
    if (isLoadingSubmit) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.driverConfirmOrder(
      order.id,
      selectedPayment.id!,
      fullName.text,
      accountDetails.text,
      phoneNumber.text,
    );
    if (success) {
      Get.back();
      Get.back();
      driverHomeController!.refreshCurrOrders();
      Get.showSnackbar(GetSnackBar(
        message: "the car was added successfully".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }
}
