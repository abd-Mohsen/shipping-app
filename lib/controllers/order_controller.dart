import 'dart:convert';
import 'dart:io';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/models/employee_model.dart';
import 'package:shipment/models/mini_order_model.dart';
import 'package:shipment/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:shipment/models/vehicle_model.dart';
import '../services/remote_services.dart';

class OrderController extends GetxController {
  final OrderModel order;
  final DriverHomeController? driverHomeController; // handle company and customer case
  final CustomerHomeController? customerHomeController;
  final CompanyHomeController? companyHomeController;
  OrderController({
    required this.order,
    this.driverHomeController,
    this.customerHomeController,
    this.companyHomeController,
  });

  //todo: edit to handle all cases of employee (select car when accepting an order)

  @override
  void onInit() async {
    setStatusIndex();
    isEmployee = await _getStorage.read("role") == "company_employee";
    if (companyHomeController != null) getAvailableVehiclesAndEmployees();
    selectedPayment = order.paymentMethods[0];
    //todo: draw path
    if (customerHomeController != null && ["processing"].contains(order.status)) _connectTrackingSocket();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  late bool isEmployee;

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

  // to let user see if he has running orders
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
      if (Get.routing.current == "/OrderView") Get.back();
      driverHomeController!.refreshExploreOrders();
      driverHomeController!.refreshCurrOrders();
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
      if (Get.routing.current == "/OrderView") Get.back();
      customerHomeController!.refreshOrders();
      Get.showSnackbar(GetSnackBar(
        message: "request was submitted, waiting for response".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void refuseOrderCustomer() async {
    if (isLoadingSubmit) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.customerRefuseOrder(order.id);
    if (success) {
      if (Get.routing.current == "/OrderView") Get.back();
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
      if (Get.routing.current == "/OrderView") Get.back();
      driverHomeController!.refreshCurrOrders();
      Get.showSnackbar(GetSnackBar(
        message: "success".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void beginOrderDriver() async {
    if (isLoadingSubmit) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.driverBeginOrder(order.id);
    if (success) {
      if (Get.routing.current == "/OrderView") Get.back();
      driverHomeController!.refreshCurrOrders();
      Get.showSnackbar(GetSnackBar(
        message: "shipping started, user can track your location".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  //todo: not working from backend
  void finishOrderDriver() async {
    if (isLoadingSubmit) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.driverFinishOrder(order.id); //todo: do for company and employee
    if (success) {
      if (Get.routing.current == "/OrderView") Get.back();
      //todo: if user clicks and return before processing, app closes (i fixed it here, fix in all the app)
      driverHomeController!.refreshCurrOrders();
      Get.showSnackbar(GetSnackBar(
        message: "ordered delivered".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void acceptOrderCompany() async {
    if (isLoadingSubmit) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.companyAcceptOrder(order.id, selectedEmployee?.driver?.id, selectedVehicle!.id);
    //todo: do for company and employee
    if (success) {
      Get.back();
      if (Get.routing.current == "/OrderView") Get.back();
      isEmployee ? driverHomeController!.refreshCurrOrders() : companyHomeController!.refreshCurrOrders();
      isEmployee ? driverHomeController!.refreshExploreOrders() : companyHomeController!.refreshExploreOrders();
      Get.showSnackbar(GetSnackBar(
        message: "request was submitted, waiting for response".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void confirmOrderCompany() async {
    if (isLoadingSubmit) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.companyConfirmOrder(
      order.id,
      selectedPayment.id!,
      fullName.text,
      accountDetails.text,
      phoneNumber.text,
    );
    if (success) {
      Get.back();
      if (Get.routing.current == "/OrderView") Get.back();
      companyHomeController!.refreshCurrOrders();
      Get.showSnackbar(GetSnackBar(
        message: "success".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  //todo: begin and finish employee order & edit vehicle & notifications page & tracking path

  //-------------------------------------vehicle and employees-----------------------

  List<VehicleModel> availableVehicles = [];
  List<EmployeeModel> availableEmployees = [];

  bool _isLoadingVehicles = false;
  bool get isLoadingVehicles => _isLoadingVehicles;
  void toggleLoadingVehicles(bool value) {
    _isLoadingVehicles = value;
    update();
  }

  VehicleModel? selectedVehicle;
  void selectVehicle(VehicleModel? v) {
    selectedVehicle = v;
    update();
  }

  EmployeeModel? selectedEmployee;
  void selectEmployee(EmployeeModel? e) {
    selectedEmployee = e;
    update();
  }

  Future<void> getAvailableVehiclesAndEmployees() async {
    toggleLoadingVehicles(true);
    Map<String, List>? res = await RemoteServices.fetchAvailableVehiclesAndEmployees();
    if (res == null) {
      toggleLoadingVehicles(false);
      return;
    }
    availableVehicles = res["vehicles"]! as List<VehicleModel>;
    availableEmployees = res["employees"]! as List<EmployeeModel>;

    toggleLoadingVehicles(false);
  }

  //--------------------------------------Real time-----------------------------------

  MapController mapController = MapController.withPosition(
    initPosition: GeoPoint(
      latitude: 12.456789,
      longitude: 8.4737324,
    ),
  );

  late WebSocket websocket;
  bool isTracking = false;
  GeoPoint? currPosition;

  void _connectTrackingSocket() async {
    String socketUrl = 'wss://shipping.adadevs.com/ws/location-tracking/${order.id}';

    websocket = await WebSocket.connect(
      socketUrl,
      protocols: ['Token', _getStorage.read("token")],
    );

    websocket.listen(
      (message) {
        //print('Message from server: $message');
        updateMap(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
  }

  Future updateMap(message) async {
    if (!isTracking) {
      isTracking = true;
      update();
    }
    message = jsonDecode(message);
    print("${message["latitude"]}, ${message["longitude"]}");
    if (currPosition != null) mapController.removeMarker(currPosition!);
    currPosition = GeoPoint(latitude: message["latitude"], longitude: message["longitude"]);
    mapController.addMarker(
      currPosition!,
      markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.local_shipping,
          color: Colors.red,
          size: 30,
        ),
      ),
    );
    mapController.moveTo(currPosition!);
  }
}
