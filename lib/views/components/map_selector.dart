import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/edit_order_controller.dart';
import 'package:shipment/controllers/make_order_controller.dart';
import 'package:shipment/views/my_addresses_view.dart';

import 'custom_button.dart';

class MapSelector extends StatelessWidget {
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
              builder: (context) => Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                      child: CustomButton(
                        onTap: () {
                          Get.to(() => MyAddressesView(
                                makeOrderController: makeOrderController,
                                editOrderController: editOrderController,
                                isStart: start,
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
                      child: OSMFlutter(
                        controller: mapController,
                        mapIsLoading: SpinKitFoldingCube(color: cs.primary),
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
                  ],
                ),
              ),
            ).whenComplete(onClose);
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
                      start ? "starting point".tr : "destination point".tr,
                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                    ),
                    SizedBox(height: 12),
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
