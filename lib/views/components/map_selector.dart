import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class MapSelector extends StatelessWidget {
  final MapController mapController;
  final bool start;
  final String address;
  final bool isLoading;
  final void Function() onClose;
  const MapSelector({
    super.key,
    required this.mapController,
    required this.start,
    required this.address,
    required this.onClose,
    required this.isLoading,
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
            //todo: allow to choose from my addresses first
            showModalBottomSheet(
              context: context,
              enableDrag: false,
              builder: (context) => OSMFlutter(
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
