import 'dart:async';
import 'dart:math';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/location_search_model.dart';
import '../services/remote_services.dart';
import 'package:flutter/material.dart';

class MapSelectorController extends GetxController {
  MapSelectorController({required this.selectedPosition});

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        mapController.listenerMapSingleTapping.addListener(
          () async {
            if (selectedPosition != null) mapController.removeMarker(selectedPosition!);
            selectedPosition = mapController.listenerMapSingleTapping.value!;
            await mapController.addMarker(
              selectedPosition!,
              markerIcon: kMapDefaultMarker,
            );
            update();
          },
        );
      },
    );
    super.onInit();
  }

  GeoPoint? selectedPosition;

  MapController mapController = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: false,
      unFollowUser: true,
    ),
  );

  List<LocationSearchModel> searchResults = [];
  int resultIndex = -1;

  TextEditingController searchQuery = TextEditingController();
  bool searchEnabled = false;

  void toggleSearchState(bool v) {
    searchEnabled = v;
    update();
  }

  bool isMapReady = false;

  void setIsMapReady(bool v) {
    isMapReady = v;

    if (isMapReady && selectedPosition != null) {
      print(selectedPosition);
      mapController.moveTo(selectedPosition!);
      mapController.addMarker(
        selectedPosition!,
        markerIcon: kMapDefaultMarker,
      );
    }

    print("map is reay");
    update();
  }

  bool _isLoadingSearch = false;
  bool get isLoadingSearch => _isLoadingSearch;
  void toggleLoadingSearch(bool value) {
    _isLoadingSearch = value;
    update();
  }

  Timer? _debounce;
  triggerSearch() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      search();
    });
  }

  void search() async {
    if (searchQuery.text.trim().isEmpty) return;
    toggleLoadingSearch(true);
    List<LocationSearchModel> newItems = await RemoteServices.getLatLngFromQuery(searchQuery.text) ?? [];
    // if (newItems.isNotEmpty)
    clearSearch();
    searchResults.addAll(newItems);
    toggleLoadingSearch(false);
    if (searchResults.isEmpty) {
      // Get.showSnackbar(GetSnackBar(
      //   message: "no result".tr,
      //   duration: const Duration(milliseconds: 6000),
      //   backgroundColor: Colors.red,
      // ));
    }
    // else {
    //   traverseSearchResults(true);
    // }
  }

  void clearSearch() {
    searchResults.clear();
    resultIndex = -1;
    update();
  }

  void traverseSearchResults(bool next) async {
    resultIndex = next ? min(searchResults.length - 1, resultIndex + 1) : max(0, resultIndex - 1);
    print(resultIndex);
    GeoPoint geoPoint = GeoPoint(latitude: searchResults[resultIndex].lat, longitude: searchResults[resultIndex].long);
    selectedPosition = geoPoint;
    mapController.moveTo(geoPoint);
    await mapController.addMarker(
      selectedPosition!,
      markerIcon: kMapDefaultMarker,
    );
    update();
  }

  void selectSearchResults(LocationSearchModel searchModel) async {
    GeoPoint geoPoint = GeoPoint(latitude: searchModel.lat, longitude: searchModel.long);
    selectedPosition = geoPoint;
    mapController.moveTo(geoPoint);
    await mapController.addMarker(
      selectedPosition!,
      markerIcon: kMapDefaultMarker,
    );
    searchEnabled = false;
    update();
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}
