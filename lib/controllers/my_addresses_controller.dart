import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/my_address_model.dart';
import '../constants.dart';
import '../models/location_model.dart';
import '../services/remote_services.dart';
import 'make_order_controller.dart';

class MyAddressesController extends GetxController {
  late MakeOrderController? makeOrderController;
  late bool isInBackground;

  MyAddressesController({this.makeOrderController, this.isInBackground = false});

  bool get selectionMode => makeOrderController != null;

  @override
  void onInit() {
    if (!isInBackground) {
      getMyAddresses();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => selectionMapController.listenerMapSingleTapping.addListener(
          () async {
            if (selectedPosition != null) selectionMapController.removeMarker(selectedPosition!);
            selectedPosition = selectionMapController.listenerMapSingleTapping.value!;
            await selectionMapController.addMarker(
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
    }
    super.onInit();
  }

  MapController selectionMapController = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  GeoPoint? selectedPosition;
  LocationModel? selectedLocation;

  void setPosition(GeoPoint? position, bool ignoreThisSh1t) async {
    if (position == null) return;
    selectedPosition = position;
    Get.back();
    await addAddress();
  }

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

  List<MyAddressModel> myAddresses = [];

  void getMyAddresses() async {
    toggleLoading(true);
    List<MyAddressModel> newItems = await RemoteServices.fetchMyAddresses() ?? [];
    myAddresses.addAll(newItems);
    toggleLoading(false);
  }

  Future<void> refreshMyAddress() async {
    myAddresses.clear();
    getMyAddresses();
  }

  void deleteAddress(int id) async {
    bool res = await RemoteServices.deleteAddress(id);
    if (res) {
      myAddresses.removeWhere((myAddress) => myAddress.id == id);
      update();
    }
  }

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
    bool success = await RemoteServices.addAddress(selectedLocation!.addressEncoder(
      selectedPosition!.latitude,
      selectedPosition!.longitude,
    ));
    if (success) {
      Get.showSnackbar(GetSnackBar(
        message: "success".tr,
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 2500),
      ));
      refreshMyAddress();
    }
    toggleLoadingAdd(false);
  }

  Future<void> addAddressInBackground(AddressModel address) async {
    bool success = await RemoteServices.addAddress(address);
    if (success) print("${address.toString()} is added to my addresses");
  }

  //-------------------------------

  MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 33.5101876, longitude: 36.2775732),
  );

  void selectAddress(MyAddressModel myAddress) async {
    GeoPoint currPosition = GeoPoint(
      latitude: myAddress.address.latitude,
      longitude: myAddress.address.longitude,
    );
    mapController.moveTo(currPosition);
    await Future.delayed(const Duration(milliseconds: 100));
    mapController.addMarker(
      currPosition,
      markerIcon: kMapDefaultMarker,
    );
    update();
  }
}
