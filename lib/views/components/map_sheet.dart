import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/map_selector_controller.dart';
import 'package:shipment/models/location_search_model.dart';
import 'package:shipment/views/components/my_search_field.dart';

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

  // todo: if location is selected, mark it when opening

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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Center(
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 12),
                //           child: Text(
                //             "select location".tr,
                //             style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //       ),
                //       Divider(color: cs.primary, endIndent: 20, thickness: 2),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white],
                            //set stops as par your requirement
                            stops: [0.90, 1], // 50% transparent, 50% white
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            0.8, 0.1, 0.1, 0, 0, // Red channel (80% red, 10% green/blue)
                            0.1, 0.8, 0.1, 0, 0, // Green channel
                            0.1, 0.1, 0.8, 0, 0, // Blue channel
                            0, 0, 0, 1, 0, // Alpha (unchanged)
                          ]),
                          child: OSMFlutter(
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
                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                                    child: MySearchField(
                                      label: "search".tr,
                                      textEditingController: controller.searchQuery,
                                      icon:
                                          // controller.isLoadingSearch
                                          //     ? Center(
                                          //         child: SpinKitFoldingCube(
                                          //           color: cs.primary,
                                          //           size: 15,
                                          //         ),
                                          //       )
                                          //     :
                                          Icon(Icons.search, color: cs.primary),
                                      onSubmit: (s) {
                                        controller.search();
                                      },
                                      onTapOutside: (x) {
                                        controller.toggleSearchState(false);
                                      },
                                      onTapField: () {
                                        controller.toggleSearchState(true);
                                      },
                                    ),
                                    // AuthField(
                                    //   controller: controller.searchQuery,
                                    //   label: "search".tr,
                                    //   prefixIcon: controller.isLoadingSearch
                                    //       ? Center(
                                    //           child: SpinKitFoldingCube(
                                    //             color: cs.primary,
                                    //             size: 15,
                                    //           ),
                                    //         )
                                    //       : Icon(Icons.search, color: cs.primary),
                                    //   validator: (s) {
                                    //     return null;
                                    //   },
                                    //   onChanged: (s) {},
                                    //   onSubmit: (s) {
                                    //     controller.search();
                                    //   },
                                    // ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 12, right: 4, left: 4),
                                //   child: CircleAvatar(
                                //     child: controller.isLoadingSearch
                                //         ? SpinKitFoldingCube(
                                //             color: cs.onPrimary,
                                //             size: 15,
                                //           )
                                //         : IconButton(
                                //             onPressed: () {
                                //               controller.search();
                                //             },
                                //             icon: Icon(
                                //               Icons.search,
                                //               color: cs.onPrimary,
                                //             ),
                                //           ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          // Visibility(
                          //   visible: controller.isMapReady && controller.searchResults.isNotEmpty,
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Expanded(
                          //         child: Padding(
                          //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          //           child: Material(
                          //             elevation: 10,
                          //             borderRadius: BorderRadius.circular(24),
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                 color: cs.surface,
                          //                 borderRadius: BorderRadius.circular(24),
                          //               ),
                          //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          //               child: Text(
                          //                 controller.resultIndex == -1
                          //                     ? ""
                          //                     : controller.searchResults[controller.resultIndex].displayName,
                          //                 style: tt.labelMedium!.copyWith(color: cs.onSurface),
                          //                 maxLines: 2,
                          //                 overflow: TextOverflow.ellipsis,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       Card(
                          //         elevation: 10,
                          //         color: cs.surface,
                          //         child: Row(
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: [
                          //             IconButton(
                          //               onPressed: () {
                          //                 controller.traverseSearchResults(false);
                          //               },
                          //               icon: Icon(
                          //                 Icons.arrow_left_outlined,
                          //                 color:
                          //                     controller.resultIndex == 0 ? cs.onSurface.withOpacity(0.6) : cs.primary,
                          //               ),
                          //             ),
                          //             Text(
                          //               "${controller.resultIndex + 1} / ${controller.searchResults.length}",
                          //               style: tt.labelMedium!.copyWith(color: cs.onSurface),
                          //             ),
                          //             IconButton(
                          //               onPressed: () {
                          //                 controller.traverseSearchResults(true);
                          //               },
                          //               icon: Icon(
                          //                 Icons.arrow_right_outlined,
                          //                 color: controller.resultIndex == controller.searchResults.length - 1
                          //                     ? cs.onSurface.withOpacity(0.6)
                          //                     : cs.primary,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Visibility(
                            visible: controller.isMapReady && controller.searchEnabled,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: cs.surface,
                              ),
                              margin: const EdgeInsets.only(left: 12, right: 12, top: 2),
                              padding: const EdgeInsets.only(top: 8),
                              child: controller.isLoadingSearch
                                  ? SpinKitFoldingCube(color: cs.primary)
                                  : controller.searchResults.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Center(
                                            child: Text(
                                              "no data".tr,
                                              style: tt.titleSmall!.copyWith(
                                                color: cs.onSurface,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: controller.searchResults.length,
                                          itemBuilder: (context, i) {
                                            List<LocationSearchModel> list = controller.searchResults;
                                            return Column(
                                              children: [
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    radius: 17,
                                                    backgroundColor: cs.secondaryContainer,
                                                    foregroundColor: cs.onSecondaryContainer,
                                                    child: Icon(Icons.location_on_outlined, size: 20),
                                                  ),
                                                  title: Text(
                                                    list[i].name == "" ? controller.searchQuery.text : list[i].name,
                                                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Text(
                                                      list[i].displayName,
                                                      style:
                                                          tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.4)),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    controller.selectSearchResults(list[i]);
                                                  },
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: cs.onSurface.withOpacity(0.2),
                                                  indent: 60,
                                                  endIndent: 0,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Visibility(
                          visible: controller.selectedPosition != null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: FloatingActionButton(
                              onPressed: () {
                                onDone(controller.selectedPosition!, start);
                              },
                              foregroundColor: cs.onPrimary,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.check),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: FloatingActionButton(
                            onPressed: onTapMyAddresses,
                            foregroundColor: cs.onPrimary,
                            backgroundColor: cs.primary,
                            child: Icon(Icons.location_on_outlined),
                            // Text(
                            //   "select from my addresses".tr.toUpperCase(),
                            //   style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                            // ),
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
