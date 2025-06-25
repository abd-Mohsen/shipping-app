import 'dart:convert';
import 'dart:io';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/models/employee_model.dart';
import 'package:shipment/models/mini_order_model.dart';
import 'package:shipment/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:shipment/models/vehicle_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/remote_services.dart';

class OrderController extends GetxController {
  OrderModel? order;

  final int orderID;
  final DriverHomeController? driverHomeController; // handle company and customer case
  final CustomerHomeController? customerHomeController;
  final CompanyHomeController? companyHomeController;
  OrderController({
    required this.orderID,
    this.driverHomeController,
    this.customerHomeController,
    this.companyHomeController,
  });

  @override
  void onInit() async {
    isEmployee = await _getStorage.read("role") == "company_employee";
    if (companyHomeController != null || isEmployee) getAvailableVehiclesAndEmployees();
    getOrder();
    super.onInit();
  }

  bool isLoadingOrder = false;
  void toggleLoadingOrder(bool value) {
    isLoadingOrder = value;
    update();
  }

  void getOrder() async {
    toggleLoadingOrder(true);
    order = await RemoteServices.getSingleOrder(orderID, _getStorage.read("role"));
    if (order != null) {
      selectedPayment = order!.paymentMethods[0];
      setStatusIndex();
      print(order!.driversApplications.length);
    }
    toggleLoadingOrder(false);
  }

  Future<void> refreshOrder() async {
    getOrder();
  }

  MapController mapController = MapController.withPosition(
    initPosition: GeoPoint(
      latitude: 0,
      longitude: 0,
    ),
  );

  void initMap() {
    mapController.moveTo(
      GeoPoint(
        latitude: order!.startPoint.latitude,
        longitude: order!.startPoint.longitude,
      ),
    );
    mapController.addMarker(
      GeoPoint(
        latitude: order!.startPoint.latitude,
        longitude: order!.startPoint.longitude,
      ),
      markerIcon: kMapDefaultMarker,
    );
    mapController.addMarker(
      GeoPoint(
        latitude: order!.endPoint.latitude,
        longitude: order!.endPoint.longitude,
      ),
      markerIcon: kMapDefaultMarker,
    );
    //todo(later): draw path
    //todo(later): connect when button is pressed
    if (customerHomeController != null && ["processing"].contains(order!.status)) connectTrackingSocket();
    update();
  }

  bool isMapReady = false;
  setMapReady(bool v) {
    initMap();
    isMapReady = v;
    update();
  }

  final GetStorage _getStorage = GetStorage();

  late bool isEmployee;

  int statusIndex = 0;

  void setStatusIndex() {
    if (order!.status == "draft") return;
    if (order!.status == "canceled") {
      statuses.last = "canceled";
    }
    statusIndex = statuses.indexOf(order!.status);
  }

  //todo there is cancelled and 6th status
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

  List<MiniOrderModel> currOrders = []; // to let user see if he has running orders

  void getCurrOrders() async {
    toggleLoadingCurr(true);
    currOrders.clear();
    List<MiniOrderModel> newItems = await RemoteServices.fetchDriverCurrOrders() ?? [];
    currOrders.addAll(newItems);
    toggleLoadingCurr(false);
  }

  /// interacting with order
  ///
  /// todo remove refreshing home from here

  void acceptOrderDriver() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.driverAcceptOrder(order!.id);
    if (success) {
      //if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      driverHomeController!.refreshExploreOrders();
      driverHomeController!.refreshOrders();
      driverHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "request was submitted, waiting for response".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void confirmOrderCustomer(int applicationID) async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.customerAcceptOrder(order!.id, applicationID);
    if (success) {
      //if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      customerHomeController!.refreshOrders();
      customerHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "request was submitted, waiting for response".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void refuseOrderCustomer() async {
    if (isLoadingRefuse || isLoadingSubmit) return;
    toggleLoadingRefuse(true);
    bool success = await RemoteServices.customerRefuseOrder(order!.id);
    if (success) {
      if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      customerHomeController!.refreshOrders();
      customerHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "order is cancelled".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingRefuse(false);
  }

  void refuseOrderDriver() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingRefuse(true);
    bool success = isEmployee
        ? await RemoteServices.companyRefuseOrder(order!.id)
        : await RemoteServices.driverRefuseOrder(order!.id);
    if (success) {
      if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      driverHomeController!.refreshOrders();
      driverHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "order is cancelled".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingRefuse(false);
  }

  void refuseOrderCompany() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingRefuse(true);
    bool success = await RemoteServices.companyRefuseOrder(order!.id);
    if (success) {
      if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      companyHomeController!.refreshOrders();
      companyHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "order is cancelled".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingRefuse(false);
  }

  void confirmOrderDriver() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.driverConfirmOrder(
      order!.id,
      selectedPayment.id!,
      fullName.text,
      accountDetails.text,
      phoneNumber.text,
    );
    if (success) {
      Get.back();
      //if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      driverHomeController!.refreshOrders();
      driverHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "success".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void beginOrderDriver() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingSubmit(true);
    bool success = isEmployee
        ? await RemoteServices.companyBeginOrder(order!.id)
        : await RemoteServices.driverBeginOrder(order!.id);
    if (success) {
      //if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      driverHomeController!.refreshOrders();
      driverHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "shipping started, user can track your location".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void finishOrderDriver() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingSubmit(true);
    bool success = isEmployee
        ? await RemoteServices.companyFinishOrder(order!.id)
        : await RemoteServices.driverFinishOrder(order!.id);
    if (success) {
      //if (Get.routing.current == "/OrderView") Get.back();
      //todo(later): if user clicks and return before processing, app closes (i fixed it here, fix in all the app)
      refreshOrder();
      driverHomeController!.refreshOrders();
      driverHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "ordered delivered".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void acceptOrderCompany() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    buttonPressed = true;
    bool valid = isEmployee ? true : formKey.currentState!.validate();
    if (!valid) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.companyAcceptOrder(order!.id, selectedEmployee?.id);
    if (success) {
      if (!isEmployee) Get.back();
      //if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      isEmployee ? driverHomeController!.refreshOrders() : companyHomeController!.refreshOrders();
      isEmployee ? driverHomeController!.refreshExploreOrders() : companyHomeController!.refreshExploreOrders();
      isEmployee ? driverHomeController!.refreshRecentOrders() : companyHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "request was submitted, waiting for response".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  void confirmOrderCompany() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.companyConfirmOrder(
      order!.id,
      selectedPayment.id!,
      fullName.text,
      accountDetails.text,
      phoneNumber.text,
    );
    if (success) {
      if (!isEmployee) Get.back();
      //if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      companyHomeController!.refreshOrders();
      companyHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "success".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

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
    Map<String, List?>? res = await RemoteServices.fetchAvailableVehiclesAndEmployees();
    if (res == null) {
      toggleLoadingVehicles(false);
      return;
    }
    availableVehicles = res["vehicles"]! as List<VehicleModel>;
    if (res["employees"] != null) availableEmployees = res["employees"]! as List<EmployeeModel>;

    toggleLoadingVehicles(false);
  }

  //--------------------------------------Real time-----------------------------------

  //todo implement reconnection logic
  bool isLoadingMap = false;
  void toggleLoadingMap(bool value) {
    isLoadingMap = value;
    update();
  }

  late WebSocket websocket;
  bool isTracking = false;
  GeoPoint? currPosition;

  void connectTrackingSocket() async {
    if (isLoadingMap) return;
    toggleLoadingMap(true);
    print("connecting to map socket");
    String socketUrl =
        'wss://shipping.adadevs.com/ws/location-tracking/${order!.id}?token=${_getStorage.read("token")}';

    websocket = await WebSocket.connect(
      socketUrl,
      //protocols: ['Token', _getStorage.read("token")],
    );

    websocket.listen(
      (message) {
        toggleLoadingMap(false);
        //print('Message from server: $message');
        updateMap(message);
      },
      onError: (error) {
        toggleLoadingMap(false);
        print('WebSocket error: $error');
      },
    );
  }

  Future refreshMap() async {
    if (websocket.readyState == WebSocket.open) websocket.close();
    connectTrackingSocket();
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
    mapController.moveTo(currPosition!);
    await Future.delayed(Duration(milliseconds: 300)); //todo not smooth at all
    mapController.addMarker(
      currPosition!,
      markerIcon: kMapDriverMarker,
    );
  }

  //----------------------------------------

  Future<void> callPhone(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res != true) {
      print("failed");
    }
  }

  void allowToSeePhone(int applicationID) async {
    bool success = await RemoteServices.allowPhone(order!.id, applicationID);
    if (success) {
      //if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      driverHomeController!.refreshExploreOrders();
      driverHomeController!.refreshOrders();
      driverHomeController!.refreshRecentOrders();
      Get.showSnackbar(GetSnackBar(
        message: "user can now see your phone".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoadingSubmit(false);
  }

  bool get didThisDriverAcceptThisOrder {
    return order!.driversApplications.map((a) => a.driver.id).contains(_getStorage.read("id"));
  }

  void openWhatsApp(String phoneNumber) async {
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '963${phoneNumber.substring(1)}';
    }
    final Uri whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      // Handle the error
      print("WhatsApp not installed or cannot launch URL");
    }
  }
}
