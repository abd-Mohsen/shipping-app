import 'dart:math';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

import '../models/location_search_model.dart';
import '../services/remote_services.dart';
import 'package:flutter/material.dart';

class MapSelectorController extends GetxController {
  MapSelectorController({required this.mapController});

  MapController mapController;

  List<LocationSearchModel> searchResults = [];
  int resultIndex = -1;

  TextEditingController searchQuery = TextEditingController();

  bool isMapReady = false;

  void setIsMapReady(bool v) {
    isMapReady = v;
    print("map is reay");
    update();
  }

  bool _isLoadingSearch = false;
  bool get isLoadingSearch => _isLoadingSearch;
  void toggleLoadingSearch(bool value) {
    _isLoadingSearch = value;
    update();
  }

  void search() async {
    if (searchQuery.text.trim().isEmpty) return;
    toggleLoadingSearch(true);
    List<LocationSearchModel> newItems = await RemoteServices.getLatLngFromQuery(searchQuery.text) ?? [];
    if (newItems.isNotEmpty) clearSearch();
    searchResults.addAll(newItems);
    toggleLoadingSearch(false);
    if (searchResults.isEmpty) {
      Get.showSnackbar(GetSnackBar(
        message: "no result".tr,
        duration: const Duration(milliseconds: 6000),
        backgroundColor: Colors.red,
      ));
    } else {
      traverseSearchResults(true);
    }
  }

  void clearSearch() {
    searchResults.clear();
    resultIndex = -1;
    update();
    print("clearee seacrh");
  }

  void traverseSearchResults(bool next) {
    resultIndex = next ? min(searchResults.length - 1, resultIndex + 1) : max(0, resultIndex - 1);
    print(resultIndex);
    GeoPoint geoPoint = GeoPoint(latitude: searchResults[resultIndex].lat, longitude: searchResults[resultIndex].long);
    mapController.moveTo(geoPoint);
    update();
  }
}
