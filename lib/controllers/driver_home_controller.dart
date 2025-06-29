import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/constants.dart';
import '../models/order_model_2.dart';

class DriverHomeController extends GetxController {
  @override
  onInit() async {
    getRecentOrders();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  //

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

  int trackingID = 0;
  OrderModel2? currentOrder;

  Future<void> getRecentOrders({bool showLoading = true}) async {
    //
    if (currentOrder != null) trackingID = currentOrder!.id;
    print("tracking order with ID ${trackingID.toString()}");
    if (trackingID != 0) {
      _connectTrackingSocket(); //todo(later): if refreshed in real time, handle reconnection
    } else {
      setTrackingStatus("no running order");
    }
    //
  }

  Future<void> refreshRecentOrders({bool showLoading = true}) async {
    currentOrder = null;
    recentOrders.clear();

    if (showLoading) await _cleanUpWebSocket(); // Make sure everything's cleaned up first
    await getRecentOrders(showLoading: showLoading);
    //_connectTrackingSocket(); // Call this directly instead of getRecentOrders()
  }
  //

  //-----------------------------------Real Time-------------------------------------------

  //
  Position? currLocation;
  StreamSubscription? subscription;
  //

  WebSocket? websocket;
  Timer? _locationTimer;

  String trackingStatus = "your location is not tracked";

  bool _isWebSocketConnected() {
    return websocket != null && websocket!.readyState == WebSocket.open;
  }

  void setTrackingStatus(String s) {
    trackingStatus = s;
    update();
  }

  void reconnectTracking() async {
    if (trackingID == 0) return;
    await _cleanUpWebSocket(); // Clean everything up first
    _connectTrackingSocket(); // Then connect again
  }

  void _startSendingLocation() async {
    if (subscription != null) {
      return; // Already streaming
    }

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

    startCheckingLocation();
    subscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        final pos = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
        print(pos);
        if (_isWebSocketConnected()) {
          websocket!.add(jsonEncode(pos));
        }
      },
      cancelOnError: false,
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

  //bool _shouldReconnect = true;
  final Duration _initialReconnectDelay = Duration(seconds: 5);

  void startCheckingLocation() {
    _locationTimer?.cancel();

    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      bool locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!locationEnabled) {
        Get.dialog(kEnableLocationDialog(), barrierDismissible: false);
        _cleanUpWebSocket();
        setTrackingStatus("turn location on");
      }
    });
  }

  bool _isConnecting = false;

  void _connectTrackingSocket() async {
    if (_isConnecting) return;
    if (_isWebSocketConnected()) return;

    _isConnecting = true;

    try {
      await _cleanUpWebSocket();

      String socketUrl =
          'wss://shipping.adadevs.com/ws/location-tracking/$trackingID?token=${_getStorage.read("token")}';

      setTrackingStatus("connecting");

      websocket = await WebSocket.connect(socketUrl).timeout(Duration(seconds: 20));

      websocket!.listen(
        (message) {
          print('Message from server: $message');
          setTrackingStatus("tracking");
        },
        onDone: () {
          _cleanUpWebSocket();
          _scheduleReconnect();
        },
        onError: (error) {
          _cleanUpWebSocket();
          _scheduleReconnect();
        },
      );

      _startSendingLocation();
    } catch (e) {
      print('Connection attempt failed: $e');
      _cleanUpWebSocket();
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> _cleanUpWebSocket() async {
    _locationTimer?.cancel();
    _locationTimer = null;

    if (subscription != null) {
      await subscription!.cancel(); // Always cancel
      subscription = null;
    }

    if (websocket != null) {
      try {
        await websocket!.close();
      } catch (_) {}
      websocket = null;
    }

    setTrackingStatus("disconnected");
  }

  void _scheduleReconnect() {
    Future.delayed(_initialReconnectDelay, () {
      _connectTrackingSocket();
    });
  }

  @override
  void onClose() async {
    //todo: not disposing (notification still appears)
    //todo: things go to shit when i refresh (realme x)
    await _cleanUpWebSocket();
    super.dispose();
  }
}
