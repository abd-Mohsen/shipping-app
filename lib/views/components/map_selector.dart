import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/edit_order_controller.dart';
import 'package:shipment/controllers/make_order_controller.dart';
import 'package:shipment/controllers/map_selector_controller.dart';
import 'package:shipment/views/components/auth_field.dart';
import 'package:shipment/views/my_addresses_view.dart';
import 'custom_button.dart';

class MapSelector extends StatefulWidget {
  final MakeOrderController? makeOrderController;
  final EditOrderController? editOrderController;
  final MapController mapController;
  final bool start;
  final String address;
  final bool isLoading;
  final String source;
  final void Function() onClose;
  const MapSelector({
    super.key,
    required this.mapController,
    required this.start,
    required this.address,
    required this.onClose,
    required this.isLoading,
    required this.source,
    this.makeOrderController,
    this.editOrderController,
  });

  @override
  State<MapSelector> createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
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

  //todo: buttons for traversing an to clear field

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 8,
        color: cs.surface,
        borderRadius: BorderRadius.circular(32),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              enableDrag: false,
              clipBehavior: Clip.hardEdge,
              builder: (context) => GetBuilder<MapSelectorController>(
                  init: MapSelectorController(mapController: widget.mapController),
                  builder: (controller) {
                    return Container(
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                      ),
                      child: Column(
                        children: [
                          //todo add another button to select my current location (show only when map is loaded)
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                            child: CustomButton(
                              onTap: () {
                                Get.to(() => MyAddressesView(
                                      makeOrderController: widget.makeOrderController,
                                      editOrderController: widget.editOrderController,
                                      isStart: widget.start,
                                    ));
                              },
                              child: Center(
                                child: Text(
                                  "select from my addresses".tr.toUpperCase(),
                                  style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Divider(color: cs.primary, indent: 20, thickness: 2),
                                Center(
                                  child: Text(
                                    "or select from map".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                                Divider(color: cs.primary, endIndent: 20, thickness: 2),
                              ],
                            ),
                          ),
                          Expanded(
                            //height: MediaQuery.of(context).size.height / 2,
                            child: Stack(
                              children: [
                                OSMFlutter(
                                  controller: widget.mapController,
                                  mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                                  onMapIsReady: (v) {
                                    controller.setIsMapReady(true);
                                  },
                                  osmOption: OSMOption(
                                    isPicker: true,
                                    userLocationMarker: UserLocationMaker(
                                      personMarker: MarkerIcon(
                                        icon: Icon(Icons.person, color: cs.primary, size: 40),
                                      ),
                                      directionArrowMarker: MarkerIcon(
                                        icon: Icon(Icons.location_history, color: cs.primary, size: 40),
                                      ),
                                    ),
                                    zoomOption: const ZoomOption(
                                      initZoom: 16,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Visibility(
                                      visible: controller.isMapReady,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: AuthField(
                                                controller: controller.searchQuery,
                                                label: "search".tr,
                                                prefixIcon: Icon(Icons.search, color: cs.primary),
                                                validator: (s) {
                                                  return null;
                                                },
                                                onChanged: (s) {},
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12, right: 4, left: 4),
                                            child: CircleAvatar(
                                              child: controller.isLoadingSearch
                                                  ? SpinKitFoldingCube(
                                                      color: cs.onPrimary,
                                                      size: 15,
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        controller.search();
                                                      },
                                                      icon: Icon(
                                                        Icons.search,
                                                        color: cs.onPrimary,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.isMapReady && controller.searchResults.isNotEmpty,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: Material(
                                                elevation: 10,
                                                borderRadius: BorderRadius.circular(24),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: cs.surface,
                                                    borderRadius: BorderRadius.circular(24),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  child: Text(
                                                    controller.resultIndex == -1
                                                        ? ""
                                                        : controller.searchResults[controller.resultIndex].displayName,
                                                    style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            elevation: 10,
                                            color: cs.surface,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    controller.traverseSearchResults(false);
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_left_outlined,
                                                    color: controller.resultIndex == 0
                                                        ? cs.onSurface.withOpacity(0.6)
                                                        : cs.primary,
                                                  ),
                                                ),
                                                Text(
                                                  "${controller.resultIndex + 1} / ${controller.searchResults.length}",
                                                  style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    controller.traverseSearchResults(true);
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_right_outlined,
                                                    color: controller.resultIndex == controller.searchResults.length - 1
                                                        ? cs.onSurface.withOpacity(0.6)
                                                        : cs.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ).whenComplete(widget.onClose);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: cs.onSurface,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(32),
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
                      widget.start ? "starting point".tr : "destination point".tr,
                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                    ),
                    SizedBox(height: 12),
                    widget.isLoading
                        ? SpinKitThreeBounce(color: cs.primary, size: 22)
                        : SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: Directionality(
                              textDirection:
                                  (widget.address == "select location") ? TextDirection.ltr : TextDirection.rtl,
                              child: Text(
                                widget.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: tt.titleSmall!.copyWith(
                                  color: widget.address == "select location".tr
                                      ? cs.primary
                                      : cs.onSurface.withOpacity(0.5),
                                  fontWeight:
                                      widget.address == "select location".tr ? FontWeight.bold : FontWeight.normal,
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
