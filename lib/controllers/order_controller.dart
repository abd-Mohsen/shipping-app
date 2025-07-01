import 'dart:convert';
import 'dart:io';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/constants.dart';
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

  OrderController({
    required this.orderID,
  });

  late String role;

  @override
  void onInit() async {
    role = await _getStorage.read("role");
    isEmployee = role == "company_employee";
    if (role == "company" || isEmployee) getAvailableVehiclesAndEmployees();
    await getOrder();
    if (order != null && !order!.isRatedByMe) setShowRatingBox(true);
    super.onInit();
  }

  bool showRatingBox = false;
  setShowRatingBox(bool val) {
    showRatingBox = val;
    update();
  }

  bool isLoadingOrder = false;
  void toggleLoadingOrder(bool value) {
    isLoadingOrder = value;
    update();
  }

  Future getOrder() async {
    toggleLoadingOrder(true);
    order = await RemoteServices.getSingleOrder(orderID, _getStorage.read("role"));
    if (order != null) {
      if (order!.paymentMethods.isNotEmpty) selectedPayment = order!.paymentMethods[0];
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

  void initMap() async {
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

    await Future.delayed(Duration(milliseconds: 1000));
    mapController.addMarker(
      GeoPoint(
        latitude: order!.endPoint.latitude,
        longitude: order!.endPoint.longitude,
      ),
      markerIcon: kMapDefaultMarkerBlue,
    );
    //todo(later): draw path
    //todo(later): connect when button is pressed
    if (role == "customer" && ["processing"].contains(order!.status)) connectTrackingSocket();
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

  //there is cancelled and 6th status
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

  void acceptOrderDriver() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.driverAcceptOrder(order!.id);
    if (success) {
      refreshOrder();
      showSuccessSnackbar();
    }
    toggleLoadingSubmit(false);
  }

  void confirmOrderCustomer(int applicationID) async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.customerAcceptOrder(order!.id, applicationID);
    if (success) {
      refreshOrder();
      showSuccessSnackbar();
    }
    toggleLoadingSubmit(false);
  }

  void rejectOrderCustomer(int applicationID) async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingRefuse(true);
    bool success = await RemoteServices.customerRejectOrder(order!.id, applicationID);
    if (success) {
      refreshOrder();
      showSuccessSnackbar();
    }
    toggleLoadingRefuse(false);
  }

  void cancelOrder() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingRefuse(true);

    bool success = role == "customer"
        ? await RemoteServices.customerCancelOrder(order!.id)
        : role == "driver"
            ? await RemoteServices.driverCancelOrder(order!.id)
            : await RemoteServices.companyCancelOrder(order!.id);
    if (success) {
      //if (Get.routing.current == "/OrderView") Get.back();
      refreshOrder();
      showSuccessSnackbar();
    }
    toggleLoadingRefuse(false);
  }

  // void refuseOrderCompany() async {
  //   if (isLoadingSubmit || isLoadingRefuse) return;
  //   toggleLoadingRefuse(true);
  //   bool success = await RemoteServices.companyRefuseOrder(order!.id);
  //   if (success) {
  //     //if (Get.routing.current == "/OrderView") Get.back();
  //     refreshOrder();
  //     showSuccessSnackbar();
  //   }
  //   toggleLoadingRefuse(false);
  // }

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
      refreshOrder();
      showSuccessSnackbar();
    }
    toggleLoadingSubmit(false);
  }

  void beginOrderDriver() async {
    //todo check if location is on (test)
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      Geolocator.openLocationSettings();
      return;
    }
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingSubmit(true);
    bool success = isEmployee
        ? await RemoteServices.companyBeginOrder(order!.id)
        : await RemoteServices.driverBeginOrder(order!.id);
    if (success) {
      refreshOrder();
      showSuccessSnackbar();
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
      //todo(later): if user clicks and return before processing, app closes (i fixed it here, fix in all the app)
      refreshOrder();
      showSuccessSnackbar();
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
      refreshOrder();
      showSuccessSnackbar();
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
      refreshOrder();
      showSuccessSnackbar();
    }
    toggleLoadingSubmit(false);
  }

  void deleteOrder(int id) async {
    bool success = await RemoteServices.deleteCustomerOrder(id);
    if (success) {
      // todo: not showing even though response is 200
      showSuccessSnackbar();
      Get.back();
    }
  }

  //-------------------------- rating ----------------------------

  TextEditingController comment = TextEditingController();
  int rating = 0;

  void setRating(int rating) {
    this.rating = rating;
    update();
  }

  void rateOrder() async {
    if (isLoadingSubmit || isLoadingRefuse) return;
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.customerRateOrder(order!.id, comment.text, rating);
    if (success) {
      //if (Get.routing.current == "/OrderView") Get.back();
      setShowRatingBox(false);
      refreshOrder();
      showSuccessSnackbar();
    }
    toggleLoadingSubmit(false);
  }

  showSuccessSnackbar() => Get.showSnackbar(
        GetSnackBar(
          message: "success".tr,
          duration: const Duration(milliseconds: 2500),
        ),
      );

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

  //todo(later) implement reconnection logic
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
    //mapController.moveTo(currPosition!);
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

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}
