import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/controllers/make_order_controller.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/views/components/map_sheet.dart';

import '../my_addresses_view.dart';

class MapSelector extends StatelessWidget {
  final MakeOrderController? makeOrderController;
  final bool start;
  final AddressModel? address;
  final GeoPoint? selectedPoint;
  final bool isLoading;
  final String source;
  const MapSelector({
    super.key,
    required this.start,
    required this.address,
    required this.isLoading,
    required this.source,
    this.makeOrderController,
    required this.selectedPoint,
  });

  // List<LocationSearchModel> searchResults = [];
  // int resultIndex = 0;
  //
  // TextEditingController searchQuery = TextEditingController();
  //
  // bool isMapReady = false;
  //
  // bool _isLoadingSearch = false;
  // bool get isLoadingSearch => _isLoadingSearch;
  // void toggleLoadingSearch(bool value) {
  //   _isLoadingSearch = value;
  //   setState(() {});
  // }
  //
  // void search() async {
  //   toggleLoadingSearch(true);
  //   List<LocationSearchModel> newItems = await RemoteServices.getLatLngFromQuery(searchQuery.text) ?? [];
  //   searchResults.addAll(newItems);
  //   toggleLoadingSearch(false);
  // }
  //
  // void clearSearch() {
  //   searchResults.clear();
  //   resultIndex = 0;
  //   setState(() {});
  // }
  //
  // void traverseSearchResults(bool next) {
  //   resultIndex = next ? min(searchResults.length - 1, resultIndex + 1) : max(0, resultIndex - 1);
  //   GeoPoint geoPoint = GeoPoint(latitude: searchResults[resultIndex].lat, longitude: searchResults[resultIndex].long);
  //   widget.mapController.moveTo(geoPoint);
  //   setState(() {});
  // }

  ///todo(later): when choosing address from my addressees, or when edit, i the map doesnt point out to the selected
  /// point, and it only show the point i manually selected even after i choose from myAddress
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2), // Shadow color
              blurRadius: 2, // Soften the shadow
              spreadRadius: 1, // Extend the shadow
              offset: const Offset(1, 1), // Shadow direction (x, y)
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              enableDrag: false,
              transitionAnimationController: AnimationController(
                vsync: Scaffold.of(context), // or use TickerProvider
                duration: const Duration(milliseconds: 200), // control speed here
              ),
              isScrollControlled: true,
              builder: (context) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: MapSheet(
                  onDone: makeOrderController!.setPosition,
                  onTapMyAddresses: () {
                    Get.to(
                      () => MyAddressesView(
                        makeOrderController: makeOrderController,
                        isStart: start,
                      ),
                    );
                  },
                  start: start,
                  selectedPoint: selectedPoint,
                ),
              ),
            );
            //.whenComplete(makeOrderController!.setPosition);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: cs.secondaryContainer,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_pin,
                  color: cs.primary,
                  size: 35,
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      start ? "starting point".tr : "destination point".tr,
                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: 12),
                    isLoading
                        ? SpinKitThreeBounce(color: cs.primary, size: 22)
                        : SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: Text(
                              address?.toString() ?? "select location".tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: tt.titleSmall!.copyWith(
                                color: address == null ? cs.primary : cs.onSurface.withOpacity(0.5),
                                fontWeight: address == null ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                    //SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
