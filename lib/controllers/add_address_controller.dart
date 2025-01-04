import 'dart:convert';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:http/http.dart' as http;

class AddAddressController extends GetxController {
  GeoCode geoCode = GeoCode();

  MapController mapController = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  GeoPoint? currPosition;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        mapController.listenerMapSingleTapping.addListener(
          () async {
            if (currPosition != null) mapController.removeMarker(currPosition!);
            currPosition = mapController.listenerMapSingleTapping.value!;
            await mapController.addMarker(
              currPosition!,
              markerIcon: const MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              ),
            );
            // var address = await geoCode.reverseGeocoding(
            //   latitude: currPosition!.latitude,
            //   longitude: currPosition!.longitude,
            // );
            //
            // print("${address.city}===================================");
            await getAddressFromLatLng(currPosition!.latitude, currPosition!.longitude);
          },
        );
      },
    );

    super.onInit();
  }

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data); // Full address
      } else {
        print('Failed to get address');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
