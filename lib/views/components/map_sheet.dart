import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/map_selector_controller.dart';
import 'auth_field.dart';

class MapSheet extends StatelessWidget {
  final void Function()? onTapMyAddresses;
  final void Function(GeoPoint, bool) onDone;
  // final void Function() onSearch;
  // final bool isLoadingSearch;
  // final void Function(bool) onIsMapReady;
  // final bool isMapReady;
  //final TextEditingController searchQuery;
  final bool start;

  const MapSheet({
    super.key,
    this.onTapMyAddresses,
    required this.onDone,
    required this.start,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<MapSelectorController>(
        init: MapSelectorController(),
        builder: (controller) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.2,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "select location".tr,
                            style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Divider(color: cs.primary, endIndent: 20, thickness: 2),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      OSMFlutter(
                        controller: controller.mapController,
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
                                      onSubmit: (s) {
                                        controller.search();
                                      },
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
                                          color:
                                              controller.resultIndex == 0 ? cs.onSurface.withOpacity(0.6) : cs.primary,
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
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Column(
                            children: [
                              Visibility(
                                visible: controller.selectedPosition != null,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    onDone(controller.selectedPosition!, start);
                                  },
                                  foregroundColor: cs.onPrimary,
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.check),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FloatingActionButton(
                                onPressed: onTapMyAddresses,
                                foregroundColor: cs.onPrimary,
                                backgroundColor: cs.primary,
                                child: Icon(Icons.location_on_outlined),
                                // Text(
                                //   "select from my addresses".tr.toUpperCase(),
                                //   style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
