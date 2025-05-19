import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/edit_order_controller.dart';
import 'package:shipment/controllers/make_order_controller.dart';
import 'package:shipment/views/components/map_sheet.dart';

import '../my_addresses_view.dart';

class MapSelector extends StatelessWidget {
  final MakeOrderController? makeOrderController;
  final EditOrderController? editOrderController;
  final bool start;
  final String address;
  final bool isLoading;
  final String source;
  const MapSelector({
    super.key,
    required this.start,
    required this.address,
    required this.isLoading,
    required this.source,
    this.makeOrderController,
    this.editOrderController,
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

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 3,
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              enableDrag: false,
              isScrollControlled: true,
              //clipBehavior: Clip.hardEdge,
              builder: (context) => MapSheet(
                onDone: makeOrderController!.setPosition, // todo: handle for register
                onTapMyAddresses: () {
                  Get.to(
                    () => MyAddressesView(
                      makeOrderController: makeOrderController,
                      editOrderController: editOrderController,
                      isStart: start,
                    ),
                  );
                },
                start: start,
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
                            child: Directionality(
                              textDirection: (address == "select location") ? TextDirection.ltr : TextDirection.rtl,
                              child: Text(
                                address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: tt.titleSmall!.copyWith(
                                  color: address == "select location".tr ? cs.primary : cs.onSurface.withOpacity(0.5),
                                  fontWeight: address == "select location".tr ? FontWeight.bold : FontWeight.normal,
                                ),
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
