import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shipment/models/address_model.dart';
import '../models/location_model.dart';
import '../services/remote_services.dart';

class MyAddressesController extends GetxController {
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => mapController.listenerMapSingleTapping.addListener(
        () async {
          if (selectedPosition != null) mapController.removeMarker(selectedPosition!);
          selectedPosition = mapController.listenerMapSingleTapping.value!;
          await mapController.addMarker(
            selectedPosition!,
            markerIcon: const MarkerIcon(
              icon: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          );
        },
      ),
    );
    super.onInit();
  }

  //todo: refactor the map bottomsheet to use it here to select new address

  MapController mapController = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  GeoPoint? selectedPosition;
  LocationModel? selectedLocation;

  Future<void> calculateLocation() async {
    if (selectedPosition == null) return;
    selectedLocation = await RemoteServices.getAddressFromLatLng(
      selectedPosition!.latitude,
      selectedPosition!.longitude,
    );
    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isLoadingAdd = false;
  bool get isLoadingAdd => _isLoadingAdd;
  void toggleLoadingAdd(bool value) {
    _isLoadingAdd = value;
    update();
  }

  List<AddressModel> addresses = [];

  void getMyAddresses() async {
    //
  } //todo

  Future<void> addAddress() async {
    if (isLoadingAdd || selectedPosition == null) return;
    toggleLoadingAdd(true);
    await calculateLocation();
    List<String> syriaNames = ["sy", "syria", "سوريا"];
    if (!syriaNames.contains(selectedLocation!.country)) {
      Get.showSnackbar(const GetSnackBar(
        message: "اختر موقع في سوريا",
        duration: Duration(milliseconds: 2500),
      ));
      toggleLoadingAdd(false);
      return;
    }
    await RemoteServices.addAddress(selectedLocation!.addressEncoder());
    toggleLoadingAdd(false);
  }
}
