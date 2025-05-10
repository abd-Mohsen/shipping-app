import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/models/governorate_model.dart';
import 'package:shipment/models/order_model.dart';
import 'package:shipment/views/complete_account_view.dart';
import 'package:shipment/views/my_vehicles_view.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'complete_account_controller.dart';
import 'login_controller.dart';
import 'otp_controller.dart';

class DriverHomeController extends GetxController {
  @override
  onInit() async {
    isEmployee = await _getStorage.read("role") == "company_employee";
    print(isEmployee ? "an employee" : "not employee");
    getCurrentUser();
    //dont show error msgs for below requests
    getGovernorates();
    getCurrentOrders();
    getHistoryOrders();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

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
    List<OrderModel> newItems = isEmployee
        ? await RemoteServices.fetchCompanyOrders(selectedGovernorate!.id, ["available"]) ?? []
        : await RemoteServices.fetchDriverOrders(selectedGovernorate!.id, ["available"]) ?? [];
    exploreOrders.addAll(newItems);
    toggleLoadingExplore(false);
  }

  int trackingID = 0;
  void getCurrentOrders() async {
    //todo: implement pagination
    toggleLoadingCurrent(true);
    List<OrderModel> newItems = isEmployee
        ? await RemoteServices.fetchCompanyOrders(null, ["approved"]) ?? []
        : await RemoteServices.fetchDriverOrders(null, ["processing", "pending", "approved"]) ?? [];
    currOrders.addAll(newItems);
    toggleLoadingCurrent(false);
    //
    if (currOrders.isNotEmpty) trackingID = currOrders.where((order) => order.status == "processing").first.id;
    print("tracking order with ID ${trackingID.toString()}");
    if (trackingID != 0) _connectTrackingSocket();
    //
  }

  void getHistoryOrders() async {
    //todo: implement pagination
    toggleLoadingHistory(true);
    List<OrderModel> newItems = isEmployee
        ? await RemoteServices.fetchCompanyOrders(null, ["processing"]) ?? [] //todo: make it done
        : await RemoteServices.fetchDriverOrders(null, ["done"]) ?? [];
    historyOrders.addAll(newItems);
    toggleLoadingHistory(false);
    //
    if (historyOrders.isNotEmpty && isEmployee)
      trackingID = historyOrders.where((order) => order.status == "processing").first.id;
    print("tracking order with ID ${trackingID.toString()}");
    if (trackingID != 0) _connectTrackingSocket();
    //
  }
  //todo: the app is crashing sometimes when entering order page

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
    /*
      'Pending', 'Verified', 'Refused', 'No_Input',
    */
    if (!refresh && _currentUser != null) {
      if (!isEmployee && _currentUser!.driverInfo!.vehicleStatus.toLowerCase() != "verified") {
        Get.to(() => const MyVehiclesView());
        Get.showSnackbar(GetSnackBar(
          message: "you need to add a car to use the app".tr,
          duration: const Duration(milliseconds: 6000),
        ));
      }
      if (_currentUser!.idStatus.toLowerCase() != "verified" ||
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
    if (currentUser != null && await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }

  //-----------------------------------Real Time-------------------------------------------

  late WebSocket websocket;
  Timer? _locationTimer;

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
    );

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

  //todo ask for location permission
  void _startPeriodicLocationUpdates() async {
    _locationTimer?.cancel();
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

    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );

        Map pos = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
        print(pos);

        if (websocket.readyState == WebSocket.open) {
          websocket.add(jsonEncode(pos));
        } else {
          // Handle reconnection
          //_reconnectWebSocket();
        }
      } catch (e) {
        print("Error getting location: $e");
      }
    });
  }

  bool _shouldReconnect = true;
  final Duration _initialReconnectDelay = Duration(seconds: 5);

  //todo: not working if screen is off
  //todo: reconnect logic is still flawed

  void _connectTrackingSocket() async {
    while (_shouldReconnect) {
      try {
        String socketUrl =
            'wss://shipping.adadevs.com/ws/location-tracking/$trackingID?token=${_getStorage.read("token")}';

        websocket = await WebSocket.connect(
          socketUrl,
          //protocols: ['Token', _getStorage.read("token")],
          // headers: {
          //   "Upgrade": "websocket",
          //   "Connection": "upgrade",
          // },
        ).timeout(const Duration(seconds: 10));

        _startPeriodicLocationUpdates();
        //_test();

        websocket.listen(
          (message) {
            print('Message from server: $message');
          },
          onDone: () {
            print('WebSocket connection closed');
            _locationTimer!.cancel();
            if (_shouldReconnect) {
              _scheduleReconnect();
            }
          },
          onError: (error) {
            _locationTimer!.cancel();
            print('WebSocket error: $error');
            if (_shouldReconnect) {
              _scheduleReconnect();
            }
          },
        );

        break; // Exit the loop if connection succeeds
      } catch (e) {
        print('Connection attempt failed: $e');
        await Future.delayed(_initialReconnectDelay);
        //todo: handle timeout
      }
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
    websocket.close();
    // todo: not closing socket
    // todo: when i hot reload the tracking does not reconnect
    // todo: shit is getting out of hand, multiple channels are opened (_startSendingLocation is called multiple times)
    super.dispose();
  }

  void _test() async {
    _locationTimer?.cancel();
    int i = 0;
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.bestForNavigation,
      // );

      Map pos = {
        "latitude": Random().nextDouble(),
        "longitude": Random().nextDouble(),
      };
      print(pos);
      //websocket.add(jsonEncode(pos));

      // if (websocket.readyState == WebSocket.open) {
      //   websocket.add(jsonEncode(pos));
      // } else {
      // Handle reconnection
      //_reconnectWebSocket();
      //}
    });
  }
}
