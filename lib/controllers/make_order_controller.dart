import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shipment/models/location_model.dart';
import 'package:shipment/services/remote_services.dart';

class MakeOrderController extends GetxController {
  //todo: add location permission if not added automatically
  //todo: make initial position the selected position if not null

  MapController mapController1 = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  MapController mapController2 = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  GeoPoint? startPosition;
  GeoPoint? endPosition;

  LocationModel? sourceLocation;
  LocationModel? targetLocation;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        mapController1.listenerMapSingleTapping.addListener(
          () async {
            if (startPosition != null) mapController1.removeMarker(startPosition!);
            startPosition = mapController1.listenerMapSingleTapping.value!;
            await mapController1.addMarker(
              startPosition!,
              markerIcon: const MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          },
        );
        mapController2.listenerMapSingleTapping.addListener(
          () async {
            if (endPosition != null) mapController2.removeMarker(endPosition!);
            endPosition = mapController2.listenerMapSingleTapping.value!;
            await mapController2.addMarker(
              endPosition!,
              markerIcon: const MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          },
        );
      },
    );

    super.onInit();
  }

  void calculateStartAddress() async {
    // todo: add loading indicator
    if (startPosition == null) return;
    sourceLocation = await RemoteServices.getAddressFromLatLng(startPosition!.latitude, startPosition!.longitude);
    print(sourceLocation?.addressEncoder().toJson());
    update();
  }

  void calculateTargetAddress() async {
    if (endPosition == null) return;
    targetLocation = await RemoteServices.getAddressFromLatLng(endPosition!.latitude, endPosition!.longitude);
    print(targetLocation?.addressEncoder().toJson());
    update();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController otherInfo = TextEditingController();

  bool coveredCar = false;

  void toggleCoveredCar() {
    coveredCar = !coveredCar;
    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  void makeOrder() async {
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    if (sourceLocation == null || targetLocation == null) {
      Get.showSnackbar(const GetSnackBar(
        message: "اختر الموقع أولاً",
        duration: Duration(milliseconds: 2500),
      ));
      return;
    }
    List<String> syriaNames = ["sy", "syria", "سوريا"];
    if (!syriaNames.contains(sourceLocation!.country) || !syriaNames.contains(targetLocation!.country)) {
      Get.showSnackbar(const GetSnackBar(
        message: "اختر موقع في سوريا",
        duration: Duration(milliseconds: 2500),
      ));
      return;
    }
    toggleLoading(true);
    await Future.delayed(Duration(milliseconds: 2000));
    toggleLoading(false);
  }
}
