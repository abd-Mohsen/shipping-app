import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/services/remote_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order_model_2.dart';

class DriverHomeController extends GetxController {
  @override
  onInit() async {
    //getRecentOrders();
    getUserLocation();
    //
    // Use controller for instant expansion
    mapContainerScrollController.addListener(() {
      final offset = mapContainerScrollController.offset;

      // Expand immediately on scroll down
      if (offset > 0 && containerHeight != maxHeight) {
        containerHeight = maxHeight;
        hasReachedTopOnce = false;
        isAtTop = false;
        update();
      }

      if (mapContainerScrollController.position.pixels == mapContainerScrollController.position.maxScrollExtent) {
        SharedHomeController sHC = Get.find();
        sHC.getExploreOrders();
      }
    });
    //
    super.onInit();
  }

  final ScrollController mapContainerScrollController = ScrollController();

  bool hasReachedTopOnce = false;
  bool isAtTop = false;

  double baseHeight = 290;
  double maxHeight = 500;
  double containerHeight = 290;

  void expandContainer() {
    containerHeight = maxHeight;
    update();
  }

  void foldContainer() {
    containerHeight = baseHeight;
    update();
  }

  void setContainerHeight(v) {
    containerHeight = v;
    update();
  }

  //

  final GetStorage _getStorage = GetStorage();

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

  void setTrackingID(int id) {
    trackingID = id;
    update();
  }

  OrderModel2? currentOrder;

  // Future<void> getRecentOrders({bool showLoading = true}) async {
  //   if (currentOrder != null) trackingID = currentOrder!.id;
  //   if (trackingID != 0) {
  //     connectTrackingSocket();
  //   } else {
  //     setTrackingStatus("no running order");
  //   }
  //   //
  // }

  // Future<void> refreshRecentOrders({bool showLoading = true}) async {
  //   currentOrder = null;
  //   recentOrders.clear();
  //
  //   if (showLoading) await _cleanUpWebSocket(); // Make sure everything's cleaned up first
  //   await getRecentOrders(showLoading: showLoading);
  //   //_connectTrackingSocket(); // Call this directly instead of getRecentOrders()
  // }
  //----------------------------------- map -----------------------------------------------

  MapController mapController = MapController();

  List<Marker> currMarkers = [];
  List<LatLng> roadToSource = [];
  List<LatLng> roadToDestination = [];
  List<LatLng> road = [];

  Marker? driverMarker;
  Marker? sourceMarker;
  Marker? destinationMarker;

  bool mapIsReady = false;

  void onMapReady() {
    mapIsReady = true;
    //  if(currentOrder){}
    //  GeoPoint currLocation = LatLng(o, longitude);
    //  GeoPoint destinationLocation = GeoPoint(latitude: 33.5221612, longitude: 36.2768708);
    // // mapController.move(center, 7);
    //  currMarkers.add(Marker(point: point, child: child))
    //  mapController.addMarker(currLocation, markerIcon: kMapDefaultMarker);
    //  mapController.drawRoad(
    //    currLocation,
    //    destinationLocation,
    //    roadOption: RoadOption(roadColor: Colors.red, roadWidth: 20),
    //  );
  }

  Future drawOnMap(LatLng start, LatLng end) async {
    sourceMarker = Marker(point: start, child: kMapSmallMarkerCustom(const Color(0xff003366)));
    destinationMarker = Marker(point: end, child: kMapSmallMarkerCustom(const Color(0xffFFA500)));
    currMarkers.add(sourceMarker!);
    currMarkers.add(destinationMarker!);
    //await mapController.drawRoad(start, end);
    update();
  }

  // draw on click, not used now
  Future<void> drawPathOld(bool source, LatLng end) async {
    if (driverMarker == null) return;
    if ((source && roadToSource.isNotEmpty) || (!source && roadToDestination.isNotEmpty)) {
      road = source ? roadToSource : roadToDestination;
      update();
      return;
    }
    List<LatLng> newRoad = await RemoteServices.getRoadPoints(
            startLat: driverMarker!.point.latitude,
            startLng: driverMarker!.point.longitude,
            endLat: end.latitude,
            endLng: end.longitude) ??
        [];
    source ? roadToSource.addAll(newRoad) : roadToDestination.addAll(newRoad);
    road = source ? roadToSource : roadToDestination;
    update();
  }

  //todo: drawing 2 paths sometimes on start
  bool _isDrawingPath = false; // guard flag

  Future<void> drawPath() async {
    if (_isDrawingPath) return;
    if (driverMarker == null || sourceMarker == null) return;

    bool reachedSource = _getStorage.read("reached_source") != null && _getStorage.read("reached_source");

    if (!reachedSource && roadToSource.isNotEmpty) return;
    if (reachedSource && roadToDestination.isNotEmpty) return;

    _isDrawingPath = true; // prevent re-entry

    List<LatLng> newRoad = await RemoteServices.getRoadPoints(
          startLat: driverMarker!.point.latitude,
          startLng: driverMarker!.point.longitude,
          endLat: reachedSource ? destinationMarker!.point.latitude : sourceMarker!.point.latitude,
          endLng: reachedSource ? destinationMarker!.point.longitude : sourceMarker!.point.longitude,
        ) ??
        [];

    if (reachedSource) {
      roadToDestination.addAll(newRoad);
      road = roadToDestination;
    } else {
      roadToSource.addAll(newRoad);
      road = roadToSource;
    }

    _isDrawingPath = false;
    update();
  }

  //-----------------------------------Real Time-------------------------------------------

  LatLng? currLocation;
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
    connectTrackingSocket(); // Then connect again
  }

  void getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setTrackingStatus("turn location on");
      Get.dialog(kEnableLocationDialog(
        () async {
          if (await Geolocator.isLocationServiceEnabled()) {
            getUserLocation();
            Get.back();
          }
        },
      ), barrierDismissible: false);
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
    Position p = await Geolocator.getCurrentPosition();

    currLocation = LatLng(p.latitude, p.longitude);

    updateDriverMarker(p.latitude, p.longitude, true);
  }

  void _startSendingLocation() async {
    if (subscription != null) {
      return; // Already streaming
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setTrackingStatus("turn location on");
      Get.dialog(
        kEnableLocationDialog(
          () async {
            if (await Geolocator.isLocationServiceEnabled()) {
              _startSendingLocation();
              Get.back();
            }
          },
        ),
        barrierDismissible: false,
      );
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
        notificationIcon: const AndroidResource(name: "ic_notification"),
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
        updateDriverMarker(position.latitude, position.longitude, false);
        print(pos);
        if (_isWebSocketConnected()) {
          websocket!.add(jsonEncode(pos));
        }
        if (sourceMarker != null &&
            driverMarker != null &&
            arePointsClose(driverMarker!.point, sourceMarker!.point, 20)) {
          // store flag in local storage and recalculate route to end
          _getStorage.write("reached_source", true);
          drawPath();
        }
      },
      cancelOnError: false,
    );
  }

  bool arePointsClose(LatLng p1, LatLng p2, double thresholdMeters) {
    // const distance = Distance(); // Vincenty by default
    // final double meter = distance(p1, p2); // distance in meters
    const haversine = Distance(calculator: Haversine());
    double meter = haversine(p1, p2);
    return meter < thresholdMeters;
  }

  void updateDriverMarker(double lat, double long, bool moveCamera) {
    currLocation = LatLng(lat, long);
    if (moveCamera) mapController.move(LatLng(lat - 0.0002, long), 18.5);
    if (driverMarker != null) currMarkers.remove(driverMarker);
    driverMarker = Marker(
      point: LatLng(lat, long),
      child: kCurrLocation,
    );
    currMarkers.add(driverMarker!);
    drawPath();
    update();
  }

  void pointToMyLocation() {
    if (currLocation != null) {
      mapController.move(
        LatLng(currLocation!.latitude - 0.0002, currLocation!.longitude),
        18.5,
      );
    }
    //update();
  }

  final Duration _initialReconnectDelay = const Duration(seconds: 5);

  void startCheckingLocation() {
    _locationTimer?.cancel();

    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      bool locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!locationEnabled) {
        Get.dialog(
            kEnableLocationDialog(Get.dialog(kEnableLocationDialog(
              () async {
                if (await Geolocator.isLocationServiceEnabled()) {
                  getUserLocation();
                  Get.back();
                }
              },
            ), barrierDismissible: false)),
            barrierDismissible: false);
        _cleanUpWebSocket();
        setTrackingStatus("turn location on");
      }
    });
  }

  bool _isConnecting = false;

  void connectTrackingSocket() async {
    if (_isConnecting) return;
    if (_isWebSocketConnected()) return;

    _isConnecting = true;

    try {
      await _cleanUpWebSocket();

      String socketUrl =
          'wss://shipping.adadevs.com/ws/location-tracking/$trackingID?token=${_getStorage.read("token")}';

      setTrackingStatus("connecting");

      websocket = await WebSocket.connect(socketUrl).timeout(const Duration(seconds: 20));

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
      connectTrackingSocket();
    });
  }

  //--------------------------- finish order ------------------------------
  bool _isLoadingFinish = false;
  bool get isLoadingFinish => _isLoadingFinish;
  void toggleLoadingFinish(bool value) {
    _isLoadingFinish = value;
    update();
  }

  void finishOrderDriver(int orderID) async {
    if (isLoadingFinish) return;
    toggleLoadingFinish(true);

    bool success = (_getStorage.read("role") == "company_employee")
        ? await RemoteServices.companyFinishOrder(orderID)
        : await RemoteServices.driverFinishOrder(orderID);
    if (success) {
      showSuccessSnackbar();
      await _cleanUpWebSocket();
      if (sourceMarker != null) {
        currMarkers.remove(sourceMarker);
        sourceMarker = null;
      }
      if (destinationMarker != null) {
        currMarkers.remove(destinationMarker);
        destinationMarker = null;
      }
      roadToSource.clear();
      roadToDestination.clear();
      _getStorage.remove("reached_source");
      road.clear();
      CurrentUserController cUC = Get.find();
      cUC.getCurrentUser();
      SharedHomeController sHC = Get.find();
      sHC.clearCurrOrders();
      update();
    }
    toggleLoadingFinish(false);
  }

  showSuccessSnackbar() => Get.snackbar(
        "success".tr,
        "success".tr,
        colorText: Colors.white,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.done, color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      );

  // ----------------------------------call------------------------

  Future<void> callPhone(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res != true) {
      print("failed");
    }
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
  void onClose() async {
    //todo: not disposing (notification still appears)
    //things go to shit when i refresh (realme x)
    await _cleanUpWebSocket();
    mapContainerScrollController.dispose();
    super.onClose();
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

  // void test(){
  //   updateDriverMarker(sourceMarker!.point.latitude, sourceMarker!.point.longitude, false);
  //   if(arePointsClose(driverMarker!.point, sourceMarker!.point, 20)){
  //     // store flag in local storage and recalculate route to end
  //     _getStorage.write("reached_source", true);
  //     drawPath();
  //   }
  // }
}
