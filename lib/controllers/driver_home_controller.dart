import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/controllers/filter_controller.dart';
import 'package:shipment/models/governorate_model.dart';
import 'package:shipment/views/complete_account_view.dart';
import '../models/order_model_2.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'complete_account_controller.dart';
import 'home_navigation_controller.dart';
import 'login_controller.dart';
import 'otp_controller.dart';

class DriverHomeController extends GetxController {
  HomeNavigationController homeNavigationController;
  FilterController filterController;
  DriverHomeController({required this.homeNavigationController, required this.filterController});

  @override
  onInit() async {
    isEmployee = await _getStorage.read("role") == "company_employee";
    getCurrentUser();
    getGovernorates();
    getRecentOrders();
    getMyOrders();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //
  TextEditingController searchQueryMyOrders = TextEditingController();
  TextEditingController searchQueryExploreOrders = TextEditingController();

  Timer? _debounce;
  search({required bool explore}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      explore ? refreshExploreOrders() : refreshOrders();
    });
  }

  List<OrderModel2> myOrders = [];

  List<OrderModel2> recentOrders = [];

  List<String> orderTypes = ["taken", "accepted", "current", "finished"];

  List<IconData> orderIcons = [
    Icons.watch_later,
    Icons.done,
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
      homeNavigationController.changeTab(1);
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

  void getMyOrders() async {
    if (isLoading) return;
    toggleLoading(true);
    List<String> typesToFetch = [];
    if (selectedOrderTypes.contains("accepted")) typesToFetch.addAll(["approved"]);
    if (selectedOrderTypes.contains("taken")) typesToFetch.addAll(["pending", "waiting_approval"]);
    if (selectedOrderTypes.contains("current")) typesToFetch.addAll(["processing"]);
    if (selectedOrderTypes.contains("finished")) typesToFetch.addAll(["done", "canceled"]);
    List<OrderModel2> newItems = isEmployee
        ? await RemoteServices.fetchCompanyOrders(
              types: typesToFetch,
              page: 1, //todo:pagination
              searchQuery: searchQueryMyOrders.text.trim(),
              minPrice: filterController.minPrice == filterController.sliderMinPrice ? null : filterController.minPrice,
              maxPrice: filterController.maxPrice == filterController.sliderMaxPrice ? null : filterController.maxPrice,
              vehicleType: filterController.selectedVehicleType?.id,
              governorate: filterController.selectedGovernorate?.id,
              currency: filterController.selectedCurrency?.id,
            ) ??
            []
        : await RemoteServices.fetchDriverOrders(
              types: typesToFetch,
              page: 1, //todo:pagination
              searchQuery: searchQueryMyOrders.text.trim(),
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
    getMyOrders();
  }

  void getRecentOrders() async {
    if (isLoadingRecent) return;
    toggleLoadingRecent(true);
    List<String> typesToFetch = ["pending", "done", "canceled", "waiting_approval"];
    List<OrderModel2> newProcessingOrders = isEmployee
        ? await RemoteServices.fetchCompanyOrders(types: ["processing"]) ?? []
        : await RemoteServices.fetchDriverOrders(types: ["processing"]) ?? [];
    List<OrderModel2> newOrders = isEmployee
        ? await RemoteServices.fetchCompanyOrders(types: typesToFetch) ?? []
        : await RemoteServices.fetchDriverOrders(types: typesToFetch) ?? [];
    recentOrders.addAll(newProcessingOrders);
    recentOrders.addAll(newOrders);
    if (newProcessingOrders.isNotEmpty) currentOrder = newProcessingOrders.first;
    //currentOrder = newOrders.first;
    toggleLoadingRecent(false);
    //
    if (currentOrder != null) trackingID = currentOrder!.id;
    print("tracking order with ID ${trackingID.toString()}");
    if (trackingID != 0) {
      _connectTrackingSocket();
    } else {
      setTrackingStatus("no running order");
    }
    //
  }

  Future<void> refreshRecentOrders() async {
    currentOrder = null;
    recentOrders.clear();
    _shouldReconnect = false; // Temporarily disable reconnection
    await websocket?.close();
    websocket = null;
    _shouldReconnect = true;
    getRecentOrders();
  }
  //

  bool isEmployee = false;

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

  bool isLoadingRecent = false;
  void toggleLoadingRecent(bool value) {
    isLoadingRecent = value;
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

  UserModel? currentUser;

  List<GovernorateModel> governorates = [];
  GovernorateModel? selectedGovernorate;

  List<OrderModel2> exploreOrders = [];
  // List<OrderModel2> currOrders = [];
  // List<OrderModel2> historyOrders = [];

  void setGovernorate(GovernorateModel? governorate) {
    selectedGovernorate = governorate;
    refreshExploreOrders();
  }

  void getGovernorates() async {
    if (isLoadingGovernorates) return;
    toggleLoadingGovernorate(true);
    List<GovernorateModel> newItems = await RemoteServices.fetchGovernorates() ?? [];
    governorates.addAll(newItems);
    if (newItems.isNotEmpty) setGovernorate(governorates[0]);
    toggleLoadingGovernorate(false);
  }

  void getExploreOrders() async {
    if (isLoadingExplore || selectedGovernorate == null) return;
    toggleLoadingExplore(true);
    List<OrderModel2> newItems = isEmployee
        ? await RemoteServices.fetchCompanyOrders(
              governorateID: selectedGovernorate!.id, types: ["available"],
              page: 1, //todo:pagination
              searchQuery: searchQueryMyOrders.text.trim(),
              minPrice: filterController.minPrice == filterController.sliderMinPrice ? null : filterController.minPrice,
              maxPrice: filterController.maxPrice == filterController.sliderMaxPrice ? null : filterController.maxPrice,
              vehicleType: filterController.selectedVehicleType?.id,
              governorate: null,
              currency: filterController.selectedCurrency?.id,
            ) ??
            []
        : await RemoteServices.fetchDriverOrders(
              governorateID: selectedGovernorate!.id, types: ["available"],
              page: 1, //todo:pagination
              searchQuery: searchQueryMyOrders.text.trim(),
              minPrice: filterController.minPrice == filterController.sliderMinPrice ? null : filterController.minPrice,
              maxPrice: filterController.maxPrice == filterController.sliderMaxPrice ? null : filterController.maxPrice,
              vehicleType: filterController.selectedVehicleType?.id,
              governorate: null,
              currency: filterController.selectedCurrency?.id,
            ) ??
            [];
    exploreOrders.addAll(newItems);
    toggleLoadingExplore(false);
  }

  int trackingID = 0;
  // void getCurrentOrders() async {
  //   toggleLoadingCurrent(true);
  //   List<OrderModel> newItems = isEmployee
  //       ? await RemoteServices.fetchCompanyOrders(null, ["approved"]) ?? []
  //       : await RemoteServices.fetchDriverOrders(null, ["processing", "pending", "approved"]) ?? [];
  //   currOrders.addAll(newItems);
  //   toggleLoadingCurrent(false);
  //   //
  //   if (currOrders.isNotEmpty) trackingID = currOrders.where((order) => order.status == "processing").first.id;
  //   print("tracking order with ID ${trackingID.toString()}");
  //   if (trackingID != 0) {
  //     // _shouldReconnect = false; // Temporarily disable reconnection
  //     // await websocket?.close();
  //     // websocket = null;
  //     // _shouldReconnect = true;
  //     _connectTrackingSocket();
  //   }
  //   //
  // }

  // void getHistoryOrders() async {
  //   toggleLoadingRecent(true);
  //   List<OrderModel> newItems = isEmployee
  //       ? await RemoteServices.fetchCompanyOrders(null, ["processing"]) ?? []
  //       : await RemoteServices.fetchDriverOrders(null, ["done"]) ?? [];
  //   historyOrders.addAll(newItems);
  //   toggleLoadingRecent(false);
  //   //
  //   if (historyOrders.isNotEmpty && isEmployee)
  //     trackingID = historyOrders.where((order) => order.status == "processing").first.id;
  //   print("tracking order with ID ${trackingID.toString()}");
  //   if (trackingID != 0) _connectTrackingSocket();
  //   //
  // }

  Future<void> refreshExploreOrders() async {
    exploreOrders.clear();
    getExploreOrders();
  }

  // Future<void> refreshCurrOrders() async {
  //   currOrders.clear();
  //   _shouldReconnect = false; // Temporarily disable reconnection
  //   await websocket?.close();
  //   websocket = null;
  //   _shouldReconnect = true;
  //   getCurrentOrders();
  // }

  // Future<void> refreshHistoryOrders() async {
  //   historyOrders.clear();
  //   getHistoryOrders();
  // }

  Future<void> getCurrentUser({bool refresh = false}) async {
    if (isLoadingUser) return;
    toggleLoadingUser(true);
    currentUser = await RemoteServices.fetchCurrentUser();
    /*
      'Pending', 'Verified', 'Refused', 'No_Input',
    */
    if (!refresh && currentUser != null) {
      if (!isEmployee && currentUser!.driverInfo!.vehicleStatus.toLowerCase() != "verified") {
        // Get.showSnackbar(GetSnackBar(
        //   message: "you need to add a car to use the app".tr,
        //   duration: const Duration(milliseconds: 6000),
        // ));
      }
      if (currentUser!.driverInfo!.licenseStatus.toLowerCase() != "verified") {
        Get.put(CompleteAccountController(homeController: this));
        Get.to(const CompleteAccountView());
      }
      if (!currentUser!.isVerified) {
        Get.put(OTPController(currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      }
    }

    if (currentUser == null) {
      //todo(later): put first to get correct loading (in all roles)
      await Future.delayed(Duration(seconds: 10));
      getCurrentUser();
    }

    toggleLoadingUser(false);
  }

  //todo: create logout service and add loading to it
  void logout() async {
    if (currentUser != null && await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }

  //-----------------------------------Real Time-------------------------------------------

  //
  Position? currLocation;
  StreamSubscription? subscription;
  //

  WebSocket? websocket;
  Timer? _locationTimer;

  String trackingStatus = "your location is not tracked";

  void setTrackingStatus(String s) {
    trackingStatus = s;
    update();
  }

  void _startSendingLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setTrackingStatus("turn location on");
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setTrackingStatus("location permission is denied");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setTrackingStatus("Location permission is permanently denied");
      return;
    }

    final locationSettings = AndroidSettings(
      foregroundNotificationConfig: ForegroundNotificationConfig(
        notificationTitle: "tracking in progress".tr,
        notificationText: "your location is being sent to order owner".tr,
        enableWakeLock: true,
        notificationIcon: AndroidResource(name: "ic_notification"),
      ),
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
      timeLimit: null,
    );

    subscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        Map pos = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
        print(pos);
        websocket!.add(
          jsonEncode(pos),
        );
      },
      cancelOnError: false, // Continue listening even if an error occurs
    );
  }

  // void _startPeriodicLocationUpdates() async {
  //   _locationTimer?.cancel();
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     setTrackingStatus("turn location on");
  //     return;
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       setTrackingStatus("location permission is denied");
  //       return;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     setTrackingStatus("Location permission is permanently denied");
  //     return;
  //   }
  //
  //   _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
  //     try {
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.bestForNavigation,
  //       );
  //
  //       Map pos = {
  //         'latitude': position.latitude,
  //         'longitude': position.longitude,
  //       };
  //       print("Foreground location: $pos");
  //
  //       if (websocket!.readyState == WebSocket.open) {
  //         websocket!.add(jsonEncode(pos));
  //       } else {
  //         // Handle reconnection
  //         //_reconnectWebSocket();
  //       }
  //     } catch (e) {
  //       print("Error getting location: $e");
  //     }
  //   });
  // }

  bool _shouldReconnect = true;
  final Duration _initialReconnectDelay = Duration(seconds: 5);

  bool _isConnecting = false;

  void _connectTrackingSocket() async {
    // Prevent multiple simultaneous connection attempts
    if (_isConnecting || !_shouldReconnect) return;

    _isConnecting = true;

    try {
      // Close existing connection if any
      if (websocket != null && websocket!.readyState == WebSocket.open) {
        await websocket!.close();
      }

      String socketUrl =
          'wss://shipping.adadevs.com/ws/location-tracking/$trackingID?token=${_getStorage.read("token")}';

      setTrackingStatus("connecting");
      websocket = await WebSocket.connect(
        socketUrl,
      ).timeout(const Duration(seconds: 20));

      _startSendingLocation();

      websocket!.listen(
        (message) {
          print('Message from server: $message');
          setTrackingStatus("tracking");
        },
        onDone: () {
          _cleanUpWebSocket();
          if (_shouldReconnect) {
            _scheduleReconnect();
          }
        },
        onError: (error) {
          _cleanUpWebSocket();
          if (_shouldReconnect) {
            _scheduleReconnect();
          }
        },
      );
    } catch (e) {
      print('Connection attempt failed: $e');
      _cleanUpWebSocket();
      if (_shouldReconnect) {
        _scheduleReconnect();
      }
    } finally {
      _isConnecting = false;
    }
  }

  void _cleanUpWebSocket() {
    _locationTimer?.cancel();
    setTrackingStatus("disconnected");
    if (websocket != null) {
      websocket!.close(); // Close if not already closed
      websocket = null;
    }
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;

    Future.delayed(_initialReconnectDelay, () {
      _connectTrackingSocket();
    });
  }

  @override
  void onClose() {
    _shouldReconnect = false;
    _cleanUpWebSocket();
    if (websocket != null) websocket!.close();
    if (_locationTimer != null) _locationTimer!.cancel();
    if (subscription != null) subscription!.cancel();
    super.dispose();
  }
}
