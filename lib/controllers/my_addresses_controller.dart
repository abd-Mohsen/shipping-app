import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shipment/models/address_model.dart';
import '../models/location_model.dart';
import '../services/remote_services.dart';
import 'edit_order_controller.dart';
import 'make_order_controller.dart';

class MyAddressesController extends GetxController {
  late MakeOrderController? makeOrderController;
  late EditOrderController? editOrderController;

  MyAddressesController({this.makeOrderController, this.editOrderController});

  bool get selectionMode => makeOrderController != null || editOrderController != null;

  @override
  void onInit() {
    getMyAddresses();
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

  List<AddressModel> myAddresses = [];

  void getMyAddresses() async {
    toggleLoading(true);
    List<AddressModel> newItems = await RemoteServices.fetchMyAddresses() ?? [];
    myAddresses.addAll(newItems);
    toggleLoading(false);
  } //todo

  Future<void> refreshMyAddress() async {
    myAddresses.clear();
    getMyAddresses();
  }

  void deleteAddress(int id) async {
    bool res = await RemoteServices.deleteAddress(id);
    if (res) {
      myAddresses.removeWhere((address) => address.id == id);
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
    bool success = await RemoteServices.addAddress(selectedLocation!.addressEncoder());
    if (success) {
      Get.showSnackbar(GetSnackBar(
        message: "the address was added successfully".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      refreshMyAddress();
    }
    toggleLoadingAdd(false);
  }
}
