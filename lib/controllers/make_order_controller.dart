import 'dart:convert';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  String? sourceState;
  String? targetState;

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
    if (startPosition == null) return;
    sourceState = await getAddressFromLatLng(startPosition!.latitude, startPosition!.longitude);
    update();
  }

  void calculateTargetAddress() async {
    if (endPosition == null) return;
    targetState = await getAddressFromLatLng(endPosition!.latitude, endPosition!.longitude);
    update();
  }

  Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["address"]["state"];
      } else {
        print('Failed to get address');
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
