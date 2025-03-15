import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/models/governorate_model.dart';
import 'package:shipment/models/order_model.dart';
import 'package:shipment/views/complete_account_view.dart';
import 'package:shipment/views/my_vehicles_view.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'complete_account_controller.dart';
import 'login_controller.dart';
import 'otp_controller.dart';

class DriverHomeController extends GetxController {
  @override
  onInit() {
    getCurrentUser();
    getGovernorates();
    getCurrentOrders();
    getHistoryOrders();
    _connectNotificationSocket();
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

  int trackingID = 0;
  void getCurrentOrders() async {
    //todo: implement pagination
    toggleLoadingCurrent(true);
    List<OrderModel> newItems =
        await RemoteServices.fetchDriverOrders(null, ["processing", "pending", "approved"]) ?? [];
    currOrders.addAll(newItems);
    toggleLoadingCurrent(false);
    //
    trackingID = currOrders.where((order) => order.status == "approved").first.id;
    print("tracking order with ID ${trackingID.toString()}");
    _connectTrackingSocket();
    //
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

  Future<void> getCurrentUser({bool refresh = false}) async {
    toggleLoadingUser(true);
    _currentUser = await RemoteServices.fetchCurrentUser();
    //todo: dont let user do anything before user is loaded
    //todo: show (complete account) page to change id and license if not verified
    //todo: dont let user logout if user is loading (it may redirect after logout)
    //todo: do the same for customer and company
    /*
      'Pending', 'Verified', 'Refused', 'No_Input',
    */
    if (!refresh && _currentUser != null) {
      if (_currentUser!.driverInfo!.vehicleStatus == "No_Input") {
        //todo: handle the cars case
        Get.to(() => const MyVehiclesView());
      }
      if (_currentUser!.driverInfo!.idStatus.toLowerCase() != "verified" ||
          _currentUser!.driverInfo!.licenseStatus.toLowerCase() != "verified") {
        CompleteAccountController cAC = Get.put(CompleteAccountController(homeController: this));
        Get.to(const CompleteAccountView());
      }
      if (!_currentUser!.isVerified) {
        Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      }
    }

    toggleLoadingUser(false);
  }

  void logout() async {
    //todo: add loading to prevent spam
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }

  //-----------------------------------Real Time-------------------------------------------

  int notificationID = 0;
  //todo: move to notification controller

  void _connectNotificationSocket() async {
    String socketUrl = 'wss://shipping.adadevs.com/ws/notifications/';

    final websocket = await WebSocket.connect(
      socketUrl,
      protocols: ['Token', _getStorage.read("token")],
    );

    websocket.listen(
      (message) {
        print('Message from server: $message');
        message = jsonDecode(message);
        notificationService.showNotification(
          id: notificationID,
          title: message["type"] + notificationID.toString(),
          body: message["text"],
        );
        notificationID++;
      },
      onDone: () {
        print('WebSocket connection closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
  }

  late WebSocket websocket;

  void _connectTrackingSocket() async {
    //todo: only works when device is on
    //todo: location service must be on when entering the app
    String socketUrl = 'wss://shipping.adadevs.com/ws/location-tracking/$trackingID';

    websocket = await WebSocket.connect(
      socketUrl,
      protocols: ['Token', _getStorage.read("token")],
    );

    _startSendingLocation();

    websocket.listen(
      (message) {
        print('Message from server: $message');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
  }

  void _startSendingLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
      timeLimit: null,
    ); //todo: find a way to make it slower

    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        Map pos = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
        print(pos);
        websocket.add(
          jsonEncode(pos),
        );
      },
      cancelOnError: false, // Continue listening even if an error occurs
    );
  }

  @override
  void onClose() {
    websocket.close();
    super.dispose();
  }
}
